import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_course/screens//app_colors.dart' as AppColors;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'audio_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DetailAudioPage extends StatefulWidget {
  final String _Nom;
  final String _instrument;
  final String _key;
  final String _measure;
  final String _tempo;
  final String _MusicTr;
  final String _musicProject;

  final String _id;


  DetailAudioPage(this._Nom, this._instrument, this._key, this._measure,
      this._tempo, this._MusicTr, this._musicProject, this._id);

  @override
  _DetailAudioPageState createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  late AudioPlayer advancedPlayer;
  String Nomm = "";
  String instrument = "";
  String MusicTr = "";
  @override
  void initState(){
    super.initState();
    advancedPlayer= AudioPlayer();


  }
  void getNom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      Nomm = prefs.getString("Nom")!;
    });
  }
  void getinstrument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      instrument = prefs.getString("instrument")!;
    });
  }
  void getMusicTr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      MusicTr = prefs.getString("MusicTr")!;
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight=MediaQuery.of(context).size.height;
    final double screenWidth=MediaQuery.of(context).size.width;


    return Scaffold(

      backgroundColor: AppColors.audioBluishBackground,
      body: Expanded(
         child : Stack(

        children: [
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString("Nom", widget._Nom);
              prefs.setString("instrument", widget._instrument);
              prefs.setString("key", widget._key);
              prefs.setString("measure", widget._measure);
              prefs.setString("tempo", widget._tempo);
              prefs.setString("MusicTr", widget._MusicTr );
              prefs.setString("musicProject", widget._musicProject );
              prefs.setString("_id1", widget._id );

            },),
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
                      Text(widget._Nom,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Avenir"
                        ),
                      ),
                      Text(widget._instrument, style:TextStyle(
                          fontSize: 20
                      ),),
                      AudioFile(advancedPlayer:advancedPlayer, audioPath:widget._MusicTr),
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
      ),
    );
  }
}

class Product2 {


  final String Nom;
  final String instrument;
  final String key;
  final String measure;
  final String tempo;
  final String MusicTr;
  final String musicProject;
  final String id;

  Product2( this.Nom, this.instrument, this.key, this.measure, this.tempo, this.MusicTr, this.musicProject,this.id);

  @override
  String toString() {
    return 'Product1{Nom: $Nom, instrument: $instrument, key: $key, measure: $measure, tempo: $tempo, MusicTr: $MusicTr, musicProject: $musicProject, id: $id}';
  }
}