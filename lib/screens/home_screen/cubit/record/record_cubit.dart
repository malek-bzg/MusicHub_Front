import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../recordings_list/cubit/files/files_cubit.dart';
import '../../../../constants/paths.dart';
import '../../../../constants/recorder_constants.dart';
import 'package:record/record.dart';
part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());
  String _id = "";
  Record _audioRecorder = Record();
  final String _baseUrl = "10.0.2.2:3000";

  void getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _id = prefs.getString("_id1")!;
    });
  }
  void startRecording() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (permissionsGranted) {
      Directory appFolder = Directory(Paths.recording);
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        final created = await appFolder.create(recursive: true);
        print(created.path);
      }

      final filepath = Paths.recording +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          RecorderConstants.fileExtention;
      print(filepath);

      await _audioRecorder.start(path: filepath);

      emit(RecordOn());
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      print(filepath);


    } else {
      print('Permissions not granted');
    }
  }

  void stopRecording() async {
    String? path = await _audioRecorder.stop();
    emit(RecordStopped());
    print('Output path $path');
    final file1 =  await http.MultipartFile.fromPath('photos', path!);
    //final file1 = await http.MultipartFile.fromBytes('photos',  File(newFile.toString()).readAsBytesSync(),
    //filename: fileName.split("/").last);
    // Upload file
    // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

    var request = new http.MultipartRequest('PUT',Uri.http( _baseUrl,"/api/track/addMusicTr"));

    Map<String, dynamic> userData = {
      "_id1": _id,

    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = prefs.getString("_id1")!;
    print(_id);
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    print("ddddddddddddddddddddddd");
    print(_id);
    request.fields['_id']= _id;
    request.files.add(file1);
    request.headers.addAll({"Content-Type": "multipart/form-data",
    });
    var response = await request.send();
    if (response.statusCode == 200) {
      //Navigator.pushReplacementNamed(context, "/");
      print("okey ya start staneni fel lagare");
    }
    else {
      print("noooooooooooooo");
    }
  }

  Future<Amplitude> getAmplitude() async {
    final amplitude = await _audioRecorder.getAmplitude();
    return amplitude;
  }

  Stream<double> aplitudeStream() async* {
    while (true) {
      await Future.delayed(Duration(
          milliseconds: RecorderConstants.amplitudeCaptureRateInMilliSeconds));
      final ap = await _audioRecorder.getAmplitude();
      yield ap.current;
    }
  }

  void setState(Null Function() param0) {}
}