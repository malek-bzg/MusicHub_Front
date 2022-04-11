import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'musicProject_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicHome extends StatefulWidget {


  const MusicHome({Key? key}) : super(key: key);

  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  String _id = "";
  //String _id = "";
  late Future<bool> fetchedGames;

  final List<Product> _products = [];
  final String _baseUrl = "10.0.2.2:3000";

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
    fetchedGames = fetchGames();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedGames,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: _products.length,
            itemBuilder: (BuildContext context,int index, ) {
              return MusicInfo(_products[index].Nom, _products[index].style, _products[index].type, _products[index].image,_products[index].id,);
            },
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );;
  }


}
