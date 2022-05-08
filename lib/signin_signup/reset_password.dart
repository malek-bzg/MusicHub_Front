import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class UserService{

  final String _baseUrl = "192.168.1.11:3000";


  Future<String> forgotPass(Map<String,String> email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http.post(Uri.http(_baseUrl, "/api/user/forgot-password"), headers: headers, body: json.encode(email))
        .then((http.Response response) async {
      Map<String, dynamic> userData = await  json.decode(response.body);
      if(response.statusCode == 200) {
        return await new Future(() => userData["token"]);
      }
      else if(response.statusCode == 403)
        return await new Future(() => userData["token"]);
      else
        return await new Future(() => "no user");
    });
    return test;

  }

  Future<String?> ResetPassword(Map<String,String> pass,String email,String token) async {

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http.post(Uri.http(_baseUrl, "/user/resetPassword/"+email+"/"+token), headers: headers, body: json.encode(pass))
        .then((http.Response response) async {
      Map<String, dynamic> userData = await  json.decode(response.body);
      if(response.statusCode == 200) {

        return await Future(() => "modified");
      }
      else if(response.statusCode == 400) {
        return await  Future(() => "token expired");
      } else if(response.statusCode == 401) {
        return await  Future(() => "no user");
      }
    });

    return  test;

  }




}