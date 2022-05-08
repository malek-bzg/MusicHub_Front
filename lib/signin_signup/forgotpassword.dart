import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  late String? _username;
  late String? _password;

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

              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(130, 0, 130, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrangeAccent, // background
                  ),
                  child: const Text("Verif Email"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/resetpass");

                  },
                ),
              ),

            ]),
          ),
        )
    );
  }
}