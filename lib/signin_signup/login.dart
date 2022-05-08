import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'forgotpassword.dart';
import 'signup.dart';
import 'reset_password.dart';
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
  String _ph = "";
  String _na = "";

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "192.168.1.11:3000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _keyForm,
            child:ListView(children: [
              const SizedBox(
                height: 70,
              ),


              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Image.asset("assets/images/logo2.png",
                      width: 215, height: 200)),

              const SizedBox(
                height: 70,
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(  30, 0 , 30, 0 ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ), labelText: "Email"),
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
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0 , 30, 0 ),
                child: TextFormField(

                  obscureText: true,
                  decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ), labelText: "Mot de passe"),
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
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(130, 0, 130, 0),
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

                          print("3333333333333333333333333");
                          print(body['username']);
                          print(body['photoProfil']);
                          pageRoute(body['_id']);
                         // page(body['username'],body['photoProfil']);

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
                margin: const EdgeInsets.fromLTRB(130, 0, 130, 0),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // background
                  ),
                  child: const Text("Joindrez-nous"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Signup()));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  SizedBox(
                    height: 90,
                  ),
                  Text("Mot de passe oublié ?  ",
                      style: TextStyle(fontSize: 15)),
                  Center(

                    child:
                    TextButton(
                      onPressed: ()  {  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Forgotpassword())); },
                      child: Text("Cliquez ici",
                        style: TextStyle(color: Colors.orangeAccent,fontSize: 15),

                        textDirection: TextDirection.ltr, ),

                    ),

                  ),

                ],
              )
            ]),
          ),
        )
    );
  }
}
void pageRoute(String _id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("key", _id );
  //await prefs.setString("username", username );
  //await prefs.setString("photoProfil", photoProfil );


}

void page(String username , String photoProfil) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString("username", username );
  await prefs.setString("photoProfil", photoProfil );


}