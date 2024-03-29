import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String? _username;
  late String? _email;
  late String? _password;


  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "192.168.1.11:3000";
  bool circular = false;
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  @override
  void initState() {
    PickedFile _imageFile;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,

          ),
        ),
        child: Form(
        key: _keyForm,

        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Image.asset("assets/images/register.png",
                    width: 215, height: 150)),





            SizedBox(
              height: 30,
            ),



            imageProfile(),
            SizedBox(
              height: 30,
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextFormField(
                decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ), labelText: "Username"),
                onSaved: (String? value) {
                  _username = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "username ne doit pas etre vide";
                  }
                  else if (value.length < 5) {
                    return "username doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ), labelText: "Email"),
                onSaved: (String? value) {
                  _email = value;
                },
                validator: (String? value) {
                  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  if (value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if (!RegExp(pattern).hasMatch(value)) {
                    return "L'adresse email est incorrecte";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextFormField(
                obscureText: true,
                decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),labelText: "Mot de passe"),
                onSaved: (String? value) {
                  _password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  }
                  else if (value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(90, 0, 90, 0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(14),
                  primary: Colors.white70  ,
                    side: BorderSide(width: 3.0, color: Colors.orangeAccent,)
                  // background
                ),


                child: const Text("Enregistrer" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.orange)),

                onPressed: ()  async {
                  if(_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();


                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };
                    String filepath;
                    var request = new http.MultipartRequest('POST',Uri.http( _baseUrl,"/api/user/register"));
                    var stream = new http.ByteStream(_imageFile!.openRead());
                    stream.cast();

                    final file = await http.MultipartFile.fromPath('photos', _imageFile!.path);

                    request.fields['username']=_username.toString();
                    request.fields['password']=_password.toString();
                    request.fields['email']=_email.toString();
                    request.files.add(file);
                    request.headers.addAll({"Content-Type": "multipart/form-data",
                    });
                    //body: json.encode(userData);
                    var response = await request.send();
                    if (response.statusCode == 201) {
                      Navigator.pushReplacementNamed(context, "/");
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
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child:IconButton (
                alignment: Alignment.bottomLeft,
                icon: Icon(Icons.arrow_back),
                iconSize: 60,
                color: Colors.deepOrange,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
                },
              ),
            ),
          ],

        ),

      ),
      )
    );

  }

  Widget imageProfile() {
    return Center(
      child:

      Stack(
          children: <Widget>[
        CircleAvatar(
          radius: 80.0,
         backgroundColor: Colors.white,
         backgroundImage: _imageFile == null?
         AssetImage("assets/images/unknown.png") as ImageProvider : FileImage(File(_imageFile!.path))
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

