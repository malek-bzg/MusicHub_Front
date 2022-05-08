import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_course/screens//app_colors.dart' as AppColors;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'audio_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DetailAudioPage extends StatefulWidget {
  List<String> okeyyaStar = [];
  String Nomm = "";
  String instrument = "";
  String  MusicTr = "";
  var result = "" ;

  DetailAudioPage({required Key key,required this.Nomm, required this.instrument, required this.MusicTr}): super(key: key);

  @override
  _DetailAudioPageState createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  late AudioPlayer advancedPlayer;


  @override
  void initState() {
    super.initState();
    advancedPlayer= AudioPlayer();
    getNom();
    getinstrument();
    getMusicTr();
  }
  void getNom() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      widget.Nomm  = prefs.getString("Nom")!;
    });
    print("//////////////");
    print(widget.Nomm);

  }
  void getinstrument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      widget.instrument = prefs.getString("instrument")!;
    });
  }


  void getMusicTr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      widget.okeyyaStar = prefs.getStringList("MusicTr")!;
    });
    print("###############################");



  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight=MediaQuery.of(context).size.height;
    final double screenWidth=MediaQuery.of(context).size.width;

    print("555555555555555555555556666666666666666");

    return
      Scaffold(

        backgroundColor: AppColors.audioBluishBackground,
        body:  Stack(

          children: [

            Positioned(
                top:0,
                left: 0,
                right: 0,
                height: screenHeight/3,
                child: Container(
                    color:AppColors.audioBlueBackground
                )),
            Positioned(
                top:0,
                left: 0,
                right: 0,
                child: AppBar(
                  leading: IconButton(
                    icon:Icon(Icons.arrow_back_ios,),
                    onPressed: (){
                      Navigator.of(context).pop();
                      advancedPlayer.stop();
                    },
                  ),

                  actions: [
                    IconButton(
                      icon:Icon(Icons.search,),
                      onPressed: (){},
                    )
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                )),

            Positioned(
                left: 0,
                right: 0,
                top: screenHeight*0.2,
                height: screenHeight*0.36,
                child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color:Colors.white,
                    ),
                    child:Column(

                      children: [
                        SizedBox(height: screenHeight*0.1,),
                        Text(widget.Nomm,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Avenir"
                          ),
                        ),
                        Text(widget.instrument, style:TextStyle(
                            fontSize: 20
                        ),),

                        AudioFile(advancedPlayer:advancedPlayer, audioPath:widget.okeyyaStar[0]),
                      ],
                    )

                )),
            Positioned(
                top:screenHeight*0.12,
                left: (screenWidth-150)/2,
                right: (screenWidth-150)/2,
                height: screenHeight*0.16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color:Colors.tealAccent, width: 1),
                    color:Colors.black,

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.circle,
                          border: Border.all(color:Colors.black, width: 2),
                          image:DecorationImage(
                              image:AssetImage("assets/images/logo.png"),
                              fit:BoxFit.cover
                          )
                      ),
                    ),
                  ),
                )

            )
          ],
        ),

      );

  }
}
