import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicInfo extends StatefulWidget {
  final String _Nom;
  final String _style;
  final String _type;
  final String _image;
  final String _id;

  MusicInfo(this._Nom, this._style, this._type, this._id, this._image);

  @override
  State<MusicInfo> createState() => _MusicInfoState();
}



class _MusicInfoState extends State<MusicInfo> {
  String _id = "";
  //String _id = "";
  final List<Product> _products = [];
  late Future<bool> fetchedGames;
  TextEditingController name = TextEditingController();
  Future<bool> fetchGames() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState((){
      _id = prefs.getString("key")!;//_id = prefs.getString("ObjectId")!;
    });

    http.Response response = await http.get(Uri.http(_baseUrl, "/api/musicproject/get-my/"+_id));

    List<dynamic> gamesFromServer = json.decode(response.body);

    for(int i = 0; i < gamesFromServer.length; i++) {
      Map<String, dynamic> gameFromServer = gamesFromServer[i];
      _products.add(Product(gameFromServer["Nom"], gameFromServer["style"], gameFromServer["type"], gameFromServer["photo"],gameFromServer["_id"],));
    }

    return true;
  }
  @override
  void initState() {
    _username = "";
    fetchedGames = fetchGames();
    super.initState();
  }
  late String? _username;
  final String _baseUrl = "192.168.1.11:3000";
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(

      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("Nom", widget._Nom);
          prefs.setString("style", widget._style);
          prefs.setString("type", widget._type);
          prefs.setString("photo", widget._image);
          prefs.setString("_id", widget._id);
          Navigator.pushNamed(context, "/THome");
          //print("111111111111111111");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Image.network(widget._image, width: 120, height: 120)),
            const SizedBox(
              height: 10,
            ),


            Column(
              children: [
                Text(widget._Nom,
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    textScaleFactor: 2),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget._style,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget._type),
                const SizedBox(
                  width: 200,
                ),
                ElevatedButton(
                  key: _keyForm,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrangeAccent, // background
                  ),
                  child: const Text("Send Invitation"),
                  onPressed: () {
                    showDialog(context: context, builder: (context) => AlertDialog(

                      title: Text('User Email'),
                      content: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ), labelText: "Email"),
                        controller: name,
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
                      actions:[
                        TextButton(child: Text('Sen Invitation'),
                          onPressed: () {
                            String name1 = name.text;
                            String id =widget._id;
                            Map<String, dynamic> userData = {
                              "id2": id,
                              "email": name1,
                            };
                            print("2222222222222222222222222222222222");
                            print(name1);
                            print(widget._id);
                            Map<String, String> headers = {
                              "Content-Type": "application/json; charset=UTF-8"
                            };

                            http.post(Uri.http(_baseUrl, "/api/musicproject/send-inv"),
                                headers: headers, body: json.encode(userData))
                                .then((http.Response response) async {
                              if (response.statusCode == 200) {
                                final body = jsonDecode(response.body);


                                Navigator.pushNamed(context, "/music");
                              }
                              else if (response.statusCode == 401) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text("Information"),
                                        content: Text(
                                            "Username et/ou mot de passe incorrect"),
                                      );
                                    });
                              }
                              else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text("Information"),
                                        content: Text(
                                            "Une erreur s'est produite. Veuillez réessayer !"),
                                      );
                                    });
                              }
                            });
                          }
                          ,
                        ),
                      ],
                    ));

                  },
                ),
              ],
            ),

            InkWell(

              child: Icon(Icons.restore_from_trash_outlined,
                  size: 30, color: Colors.deepOrange),
              onTap: () async {
                Map<String, String> headers = {
                  "Content-Type": "application/json; charset=UTF-8"
                };
                Map<String, dynamic> userData = {
                  "_id": widget._id,
                };
                http
                    .delete(Uri.http(_baseUrl, "/api/musicproject/"),
                    headers: headers, body: json.encode(userData))
                    .then((http.Response response) {
                  if (response.statusCode == 201) {
                    final body = jsonDecode(response.body);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Material Dialog'),
                            content: Text('Hey! I am Coflutter!'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {

                                  },
                                  child: Text('Close')),
                              TextButton(
                                onPressed: () {
                                  print('HelloWorld!');
                                  fetchedGames = fetchGames();
                                },
                                child: Text('delete!'),
                              )
                            ],
                          );
                        });

                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("Information"),
                            content: Text(
                                "Une erreur s'est produite. Veuillez réessayer !"),
                          );
                        });
                  }
                });
              },
            ),

          ],
        ),
      ),
    );
  }

}

class Product {
  final String Nom;
  final String style;
  final String type;
  final String image;
  final String id;

  Product(this.Nom, this.style, this.type, this.id, this.image);

  @override
  String toString() {
    return 'Product{Nom: $Nom, style: $style, type: $type, image: $image, id: $id}';
  }
}