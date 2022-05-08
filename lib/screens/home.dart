import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/widgets/category_box.dart';
import 'package:online_course/widgets/feature_item.dart';
import 'package:online_course/widgets/notification_box.dart';
import 'package:online_course/widgets/recommend_item.dart';
import 'musicProject_info.dart';
import 'dart:developer';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: appBgColor,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            pinned: true,
            snap: true,
            floating: true,
            title: getAppBar(),
          ),
          SliverList(

            delegate: SliverChildBuilderDelegate(
              (context, index) => buildBody(),
              childCount: 1,
            ),
          )
        ],
      )
    );
  }

  Widget getAppBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(

                  width: 300,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Image.asset(
                    "assets/images/logo4.png",
                  ))),
        ],
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [

          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text("PROJECTS",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
          ),
          getRecommend(),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          getFeature(),


        ]),
      ),
    );
  }

  int selectedCollection = 0;
  getCategories() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 160.0,
            color: Colors.red,
          ),
          Container(
            width: 160.0,
            color: Colors.blue,
          ),
          Container(
            width: 160.0,
            color: Colors.green,
          ),
          Container(
            width: 160.0,
            color: Colors.yellow,
          ),
          Container(
            width: 160.0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  getFeature() {
    return CarouselSlider(
        options: CarouselOptions(
          height: 290,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .75,
        ),
        items: List.generate(features.length,
            (index) => FeatureItem(onTap: () {}, data: features[index])));
  }

  String _id = "";
  //String _id = "";
  late Future<bool> fetched;

  final List<rec> _products = [];
  final String _baseUrl = "192.168.1.11:3000";

  Future<bool> fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getString("key")!; //_id = prefs.getString("ObjectId")!;
      print(_id);
    });

    http.Response response =
        await http.get(Uri.http(_baseUrl, "/api/musicproject/get-my/" + _id));

    List<dynamic> games = json.decode(response.body);

    for (int i = 0; i < games.length; i++) {
      Map<String, dynamic> game = games[i];
      _products.add(rec(
        game["Nom"],
        game["style"],
        game["type"],
        game["photo"],
        game["_id"],
      ));
    }

    return true;
  }

  @override
  void initState() {
    fetched = fetch();
    super.initState();
  }

  getRecommend() {
    return FutureBuilder(
        future: fetched,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                      _products.length,
                      (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RecommendItem(
                            _products[index].Nom,
                            _products[index].style,
                            _products[index].type,
                            _products[index].id,
                            _products[index].image,
                          )))),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }



}
