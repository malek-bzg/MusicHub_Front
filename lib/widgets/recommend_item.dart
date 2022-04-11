import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/custom_image.dart';
import 'package:online_course/screens/musicProject_info.dart';
class RecommendItem extends StatefulWidget {
  final String _Nom;
  final String _style;
  final String _type;
  final String _image;
  final String _id;


  RecommendItem(this._Nom, this._style, this._type,  this._id,this._image);
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  State<RecommendItem> createState() => _RecommendItemState();
}

class _RecommendItemState extends State<RecommendItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap:  () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();


        prefs.setString("Nom", widget._Nom);
        prefs.setString("style", widget._style);
        prefs.setString("type", widget._type);
        prefs.setString("photo", widget._image);

        prefs.setString("_id", widget._id );
        Navigator.pushNamed(context, "/THome");
        //print("111111111111111111");
      },
      child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: Image.network(widget._image,
                      )),),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget._Nom, maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Text(widget._type,
                    style: TextStyle(fontSize: 14, color: textColor),),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, color: labelColor,
                        size: 14,),
                      SizedBox(width: 2,),
                      Text(widget._style, style: TextStyle(
                          fontSize: 12, color: labelColor),),
                      SizedBox(width: 20,),
                      Icon(Icons.star, color: orange, size: 14,),
                      SizedBox(width: 2,),

                    ],
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
class rec {
  final String Nom;
  final String style;
  final String type;
  final String image;
  final String id;

  rec(this.Nom, this.style, this.type,this.image,this.id);

  @override
  String toString() {
    return 'rec{Nom: $Nom, style: $style, type: $type, image: $image, id: $id}';
  }
}