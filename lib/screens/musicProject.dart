import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MusicProject extends StatefulWidget {

   const MusicProject({Key? key}) : super(key: key);


  @override
  _MusicProjectState createState() => _MusicProjectState();
}

class _MusicProjectState extends State<MusicProject> {
  late String? _nom;
  late String? _style;
  late String? _type;
  String _id = "";

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final String _baseUrl = "10.0.2.2:3000";
  bool circular = false;
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  @override
  void initState() {
    PickedFile _imageFile;
    super.initState();
    get();
  }
  void get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _id = prefs.getString("key")!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("creatMusicProject"),
      ),
    body: Form(
      key: _keyForm,
      child: ListView(
          children: [
            //Container(
               // width: double.infinity,
               // margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                //child: Image.asset("assets/images/newP.jpg", width: 460, height: 215)
            //),
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Name Of Project"),
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
                    border: OutlineInputBorder(), labelText: "Style"),
                onSaved: (String? value) {
                  _style = value;
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
                    border: OutlineInputBorder(), labelText: "Type"),
                onSaved: (String? value) {
                  _type = value;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Create"),
                  onPressed: () async {
                    if(_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();

                      Map<String, dynamic> userData = {
                        // "profilePicture": _username,
                        "Nom" : _nom,
                        "type" : _type,
                        "style" : _style,
                        "user" : _id,

                      };

                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };

                      var request = new http.MultipartRequest('POST',Uri.http( _baseUrl,"/api/musicproject/"));
                      var stream = new http.ByteStream(_imageFile!.openRead());
                      stream.cast();

                      final file = await http.MultipartFile.fromPath('photos', _imageFile!.path);

                      request.fields['Nom']=_nom.toString();
                      request.fields['type']=_type.toString();
                      request.fields['style']=_style.toString();
                      request.fields['user']= _id;
                      request.files.add(file);
                      body: json.encode(userData);
                      request.headers.addAll({"Content-Type": "multipart/form-data",
                      });
                      //body: json.encode(userData);
                      var response = await request.send();

                        if(response.statusCode == 201) {

                          Navigator.pushNamed(context, "/music");
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

                    }
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text("next"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/music");
                  },
                )
              ],
            )
          ],
      ),
    ),

    );
  }
  void pageRoute1(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("key", token );

  }
  Widget imageProfile() {
    return Center(
      child:

      Stack(
          children: <Widget>[
            CircleAvatar(
                radius: 80.0,
                backgroundImage: _imageFile == null?
                AssetImage("assets/images/logo.png") as ImageProvider : FileImage(File(_imageFile!.path))
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 28.0,
                ),
              ),
            ),
          ]
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
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;

    });
  }
}
