import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  List<String> items = [" F#", "G#", "A#", "B", "C#", "D#"];
  String? key = ' F#' ;
  List<String> items1 = [" broad (40 - 58 bpm)", "slow (60 - 76 bpm) ", " speed (80 - 106 bpm) ", " pace (108 - 118 bpm) ", "fast_cheerful(120 - 168 bpm)", "fast (170 - 220 b.p.m) "];
  String? tempo = ' broad (40 - 58 bpm)' ;

  List<String> items2 = [" Rhythm : measure", "4/4 ", "C " ," 2/2 ", " 3/4", "6/8"];
  String? measure = ' Rhythm : measure' ;

  late String? _nom;
  late String? _instrument;
  late String? _key;
  late String? _measure;
  late String? _tempo;

  String id = "";
  String _id = "";
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final String _baseUrl = "192.168.1.11:3000";
  @override
  void initState() {
    super.initState();
    getid();
    gettoken();
  }
  void gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _id = prefs.getString("key")!;
    });
  }
  void getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      id = prefs.getString("_id")!;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/newtrack.png", width: 460, height: 215)
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Name Of Track"),
                onSaved: (String? value) {
                  _nom = value;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Field must not be empty";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "instrument"),
                onSaved: (String? value) {
                  _instrument = value;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Field must not be empty";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: DropdownButton<String>(
                value: key,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 24)),
                )).toList(),
                onChanged: (item)=> setState(() =>key = item ),

              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: DropdownButton<String>(
                value: measure,
                items: items2
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 24)),
                )).toList(),
                onChanged: (item)=> setState(() =>measure = item ),

              ),
            ),

            Container(
              child :Flexible(
                child: DropdownButton<String>(
                  value: tempo,
                  items: items1
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 24)),
                  )).toList(),
                  onChanged: (item)=> setState(() =>tempo = item ),

                ),
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Create"),
                  onPressed: () {
                    if(_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();

                      Map<String, dynamic> userData = {
                        // "profilePicture": _username,
                        "Nom" : _nom,
                        "instrument" : _instrument,
                        "key" : key,
                        "measure" : measure,
                        "tempo" : tempo,

                        "user" : _id,
                        "musicProject" : id

                      };

                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };
                      print(_id);
                      print(id);
                      http.post(Uri.http(_baseUrl, "/api/track/"), headers: headers, body: json.encode(userData))
                          .then((http.Response response) {
                        if(response.statusCode == 201) {
                          print(_id);
                          print(id);

                          //Navigator.pushReplacementNamed(context, "/");
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
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () {

                  },
                )
              ],
            )
          ],
        ),
      ),

    );
  }
}