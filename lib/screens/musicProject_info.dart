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
final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
class _MusicInfoState extends State<MusicInfo> {

  final String _baseUrl = "10.0.2.2:3000";




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
          prefs.setString("_id", widget._id );
          Navigator.pushNamed(context, "/THome");
          //print("111111111111111111");
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                child: const Icon(Icons.restore_from_trash_rounded, size: 50,color: Colors.teal),
                onTap: () async {
                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };
                  Map<String, dynamic> userData = {
                    "_id": widget._id,

                  };
                  http.delete(
                    Uri.http(_baseUrl, "/api/musicproject/"), headers: headers,body: json.encode(userData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      final body =jsonDecode(response.body);

                      //Navigator.pushReplacementNamed(context, "/");
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
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Image.network(widget._image,
                    width: 120, height: 120)),

            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(widget._Nom,style:TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold), textScaleFactor: 2),
                const SizedBox(
                  height: 10,
                ),
                Text(widget._style,),
                const SizedBox(
                  height: 10,
                ),
                Text(widget._type),
              ],
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
