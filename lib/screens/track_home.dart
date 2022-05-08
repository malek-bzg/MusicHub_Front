import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_course/screens/track_info.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TrackHome extends StatefulWidget {
  const TrackHome({Key? key}) : super(key: key);

  @override
  _TrackHomeState createState() => _TrackHomeState();
}

class _TrackHomeState extends State<TrackHome> {
  String _id = "";

  late Future<bool> fetchtrack;
  late List<String> _products2 = [];
  final List<Product1> _products1 = [];
  final String _baseUrl = "192.168.1.11:3000";
  Future<bool> Trackfet() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState((){
      _id = prefs.getString("_id")!;
      //_id = prefs.getString("ObjectId")!;
    });
    http.Response response = await http.get(Uri.http(_baseUrl, "/api/track/get-my/"+_id));

    List<dynamic> S= json.decode(response.body);




    for(int i = 0; i < S.length; i++) {
      Map<dynamic, dynamic> Server = S[i];
      //print(S[i]);
      // print(Server["Nom"]);
      //print(Server["instrument"]);
      //print(Server["key"]);
      print(Server["MusicTr"][0]);
      print("222222222222222222222222");


      //List<String> _products3 = [...Server["MusicTr"]];
      List<String> _products3 = [];
      _products3.insert(0, Server["MusicTr"][0]);
      print(_products3);
      _products1.add(Product1( Server["Nom"].toString(), Server["instrument"].toString(),Server["key"].toString(),Server["measure"].toString(),Server["tempo"].toString(), _products3, Server["musicProject"].toString(),Server["_id"].toString()));
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
            return ListView.builder(
              itemCount: _products1.length,
              itemBuilder: (BuildContext context,int index) {
                return TrackInfo( _products1[index].Nom, _products1[index].instrument,_products1[index].key,_products1[index].measure,_products1[index].tempo,_products1[index].MusicTr,_products1[index].musicProject,_products1[index].id);
              },
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