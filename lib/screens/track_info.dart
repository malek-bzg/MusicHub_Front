import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/screens/home_screen/cubit/record/record_cubit.dart';
import 'package:online_course/screens/home_screen/home_screen.dart';
import 'package:online_course/screens/recordings_list/cubit/files/files_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_course/audio/detail_audio_page.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
class TrackInfo extends StatefulWidget {

  final String _Nom;
  final String _instrument;
  final String _key;
  final String _measure;
  final String _tempo;
  final List<String> _MusicTr;
  final String _musicProject;


  final String _id;

  TrackInfo(  this._Nom, this._instrument, this._key, this._measure, this._tempo,this._MusicTr, this._musicProject,this._id,);

  @override
  _TrackInfoState createState() => _TrackInfoState();
}

class _TrackInfoState extends State<TrackInfo> {

  //PlatformFile? file;
  PickedFile? _imageFile;
  String musicProject = "";
  String _id = "";

  get newPath => null;

  File? get sourceFile => null;

  void initState() {
    PickedFile _imageFile;
    super.initState();
    getid();
  }


  void getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _id = prefs.getString("_id1")!;
    });
  }
  final String _baseUrl = "192.168.1.11:3000";
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("Nom", widget._Nom);
          prefs.setString("instrument", widget._instrument);
          prefs.setString("key", widget._key);
          prefs.setString("measure", widget._measure);
          prefs.setString("tempo", widget._tempo);
          prefs.setStringList("MusicTr", widget._MusicTr );
          prefs.setString("musicProject", widget._musicProject );
          prefs.setString("_id1", widget._id );

          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>DetailAudioPage(key: ValueKey(int), Nomm: '', instrument: '', MusicTr: '',))
          );
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                child: const Icon(Icons.restore_from_trash_rounded, size: 50,),
                onTap: () async {
                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };
                  Map<String, dynamic> userData = {
                    "_id1": widget._id,

                  };
                  http.delete(
                      Uri.http(_baseUrl, "/api/track/"), headers: headers,body: json.encode(userData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
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

            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(widget._Nom),
                const SizedBox(
                  height: 10,
                ),
                Text(widget._instrument, textScaleFactor: 2),
                const SizedBox(
                  height: 10,
                ),
                Text(widget._key),

              ],
            ),

            Row(
              children:[
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            Expanded(child: Column()),
            Column(

              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(

                    onPressed:() {

                      Navigator.pushNamed(context, "/homescreen");

                    },
                    child: const Text("Record")
                ),
                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),),
                  child: const Text("ADD TRACK"),
                  onPressed: () async {

                    FilePickerResult? result = await FilePicker.platform.pickFiles();


                    if (result != null) {
                      File file = File(result.files.single.path!);
                    } else {
                      // User canceled the picker
                    }






                    //FilePickerResult? result1 = await FilePicker.platform.pickFiles();





                    if (result != null) {
                      print("6565655656565656565656");
                      //Uint8List? fileBytes = result.files.first.bytes;


                      PlatformFile file = result.files.first;
                      print('222222222222222222222222221');
                      print(file.name);
                      print("5555555555555555555555555555555");
                      print(file.bytes);
                      print(file.size);
                      print(file.extension);
                      print("6666666666666666666666666");
                      print(file.path);
                      final newFile = await _buttonPressed(file);
                      String fileName = result.files.first.name;
                      print(fileName);


                      //final file1 = result.files.first.path.toString();
                      //final file1 = File(pickedFile!.path!).toString();
                      print("6565655656565656565656");
                      /*final file = await http.MultipartFile('photos', File(fileName).readAsBytes().asStream(),
                           File(fileName).lengthSync(),
                           filename: fileName.split("/").last);*/
                      print(file.path!);
                      final file1 =  await http.MultipartFile.fromPath('photos', file.path!);
                      //final file1 = await http.MultipartFile.fromBytes('photos',  File(newFile.toString()).readAsBytesSync(),
                      //filename: fileName.split("/").last);
                      // Upload file
                      // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

                      var request = new http.MultipartRequest('PUT',Uri.http( _baseUrl,"/api/track/addMusicTr"));

                      Map<String, dynamic> userData = {
                        "_id1": widget._id,

                      };

                      print(widget._id);
                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };
                      print("ddddddddddddddddddddddd");
                      print(_id);
                      request.fields['_id']= widget._id;
                      request.files.add(file1);
                      request.headers.addAll({"Content-Type": "multipart/form-data",
                      });
                      var response = await request.send();
                      if (response.statusCode == 200) {
                        //Navigator.pushReplacementNamed(context, "/");
                        print("okey ya start staneni fel lagare");
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
                    }






                  },
                ),
              ],
            ),
          ],
        ),

      ),

    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Track",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[

            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () async {

                //FilePickerResult? result = await FilePicker.platform.pickFiles();
                final result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file = File(result.files.single.path.toString());
                } else {
                  // User canceled the picker
                }






                PlatformFile file = result!.files.first;
                print('222222222222222222222222221');
                print(file.name);
                print("5555555555555555555555555555555");
                print(file.bytes);
                print(file.size);
                print(file.extension);
                print("6666666666666666666666666");
                print(file.path);
                final newFile = await _buttonPressed(file);
                print('From path:${file.path!} ');
                print('TO path:${newFile.path} ');

                //var basNameWithExtension = path.basename(file.path!);
                //var file1 =  await moveFile(sourceFile!,newPath+"/"+basNameWithExtension);



              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Future getFile() async {
    //final path = '${pickedFile!.name}';
    //final file = File(pickedFile!.path!);
    //File file = await FilePicker.getFile();
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
  /*Future<File>  _getLocalFile(String pathFlie) async {
    final root = await await getApplicationDocumentsDirectory();
    final path = root+'/'+pathFile;
    return File(path).create(recursive: true);
  }*/

  Future<File> saveFilePermanently(PlatformFile file) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
  Future<File> _buttonPressed(PlatformFile file) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    File ourFile = File('$appDocPath/greeting.txt');
    print(appDocDir.listSync());
    return ourFile;

  }


  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }


}
class Product1 {

  final String id;
  final String Nom;
  final String instrument;
  final String key;
  final String measure;
  final String tempo;
  final List<String> MusicTr;
  final String musicProject;


  Product1( this.Nom, this.instrument, this.key, this.measure, this.tempo, this.MusicTr, this.musicProject,this.id);

  @override
  String toString() {
    return 'Product1{Nom: $Nom, instrument: $instrument, key: $key, measure: $measure, tempo: $tempo, MusicTr: $MusicTr, musicProject: $musicProject, id: $id}';
  }
}