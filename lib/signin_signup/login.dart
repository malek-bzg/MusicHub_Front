import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String? _username;
  late String? _password;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "10.0.2.2:3000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _keyForm,
        child:ListView(children: [
          const SizedBox(
            width: 20,
          ),

          const Text(
            "Music Hub",
            style: TextStyle(
                fontSize: 50,
                color: Colors.blueGrey
            ),
            textAlign: TextAlign.center,

          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Image.asset("assets/images/logo.png",
                  width: 215, height: 380)),

          Container(
            margin: const EdgeInsets.fromLTRB(30, 10 , 30, 0 ),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
              onSaved: (String? value) {
                _username = value;
              },
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return "Le username ne doit pas etre vide";
                }
                else if(value.length < 5) {
                  return "Le username doit avoir au moins 5 caractères";
                }
                else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20 ),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Mot de passe"),
              onSaved: (String? value) {
                _password = value;
              },
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return "Le mot de passe ne doit pas etre vide";
                }
                /* else if(value.length < 5) {
                  return "Le mot de passe doit avoir au moins 5 caractères";
                }*/
                else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrangeAccent, // background
              ),
              child: const Text("S'authentifier"),
              onPressed: () {
                if(_keyForm.currentState!.validate()) {
                  _keyForm.currentState!.save();

                  Map<String, dynamic> userData = {
                    "email": _username,
                    "password" : _password
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };

                  http.post(Uri.http(_baseUrl, "/api/user/login"), headers: headers, body: json.encode(userData))
                      .then((http.Response response) async {
                    if(response.statusCode == 200) {

                      final body =jsonDecode(response.body);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("_id : ${body['_id']}")));


                      pageRoute(body['_id'],);
                      Navigator.pushNamed(context, "/home");



                    }
                    else if(response.statusCode == 401) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Username et/ou mot de passe incorrect"),
                            );
                          });
                    }
                    else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                            );
                          });
                    }
                  });
                }

              },
            ),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey, // background
              ),
              child: const Text("Créer un compte"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Signup()));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 50,
              ),
              Text("Mot de passe oublié ?  "),
              Center(

                child:
                Text("Cliquez ici",
                    style: TextStyle(color: Colors.orangeAccent),
                    textDirection: TextDirection.ltr),
              ),
            ],
          )
        ]),
      ),

    );
  }
}
void pageRoute(String _id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("key", _id );


}