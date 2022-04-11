import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_course/audio/detail_audio_page.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  String _id = "";

  late Future<bool> fetchtrack;

  final List<Product2> _products1 = [];
  final String _baseUrl = "10.0.2.2:3000";
  Future<bool> Trackfet() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState((){
      _id = prefs.getString("_id1")!;
      //_id = prefs.getString("ObjectId")!;
    });

    http.Response response = await http.get(Uri.http(_baseUrl, "/api/track/getbyid/"+_id));

    List<dynamic> S= json.decode(response.body);




    for(int i = 0; i < S.length; i++) {
      Map<String, dynamic> Server = S[i];
      //print(S[i]);
      // print(Server["Nom"]);
      //print(Server["instrument"]);
      //print(Server["key"]);
      print(Server["measure"].toString());
      _products1.add(Product2( Server["Nom"].toString(), Server["instrument"].toString(),Server["key"].toString(),Server["measure"].toString(),Server["tempo"].toString(), Server["MusicTr"].toString(), Server["musicProject"].toString(),Server["_id"].toString()));
      print(_products1);
    }
    print(_products1[0].Nom);

    return true;
  }
  @override
  void initState() {
    fetchtrack = Trackfet();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchtrack,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.hasData) {
            return Expanded(
                child :ListView.builder(
              itemCount: _products1.length,
              itemBuilder: (BuildContext context,int index) {
                return DetailAudioPage( _products1[index].Nom, _products1[index].instrument,_products1[index].key,_products1[index].measure,_products1[index].tempo,_products1[index].MusicTr,_products1[index].musicProject,_products1[index].id);
              },
            ),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
