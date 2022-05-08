import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late String? _username;
  late String? _email;
  late String? _firstName;
  late String? _lastName;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "192.168.1.11:3000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Center(child: Text('Update')),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/unknown.png", width: 150, height: 220)
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10 ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                onSaved: (String? value) {
                  _email = value;
                },
                validator: (String? value) {
                  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(!RegExp(pattern).hasMatch(value)) {
                    return "L'adresse email est incorrecte";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10 ),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "FirstName"),
                onSaved: (String? value) {
                  _firstName = value;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "firstname ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "firstname doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10 ),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "LastName"),
                onSaved: (String? value) {
                  _lastName = value;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "lastname ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "lastname doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: ElevatedButton(
                child: const Text("Enregistrer"),
                onPressed: () {
                  if(_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();

                    Map<String, dynamic> userData = {
                      // "profilePicture": _username,
                      "email" : _email,
                      "lastName" : _lastName,
                      "firstName" : _firstName
                    };

                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };

                    http.put(Uri.http(_baseUrl, "/api/user/edit-profile"), headers: headers, body: json.encode(userData))
                        .then((http.Response response) {
                      if(response.statusCode == 200) {
                        Navigator.pop(context);
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
          ],
        ),
      ),
    );;
  }
}

