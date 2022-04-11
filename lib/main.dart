import 'package:flutter/material.dart';
import 'package:online_course/screens/musicProject_home.dart';
import 'package:online_course/screens/track_home.dart';
import 'package:online_course/screens/track_office.dart';
import 'package:online_course/signin_signup/update.dart';

import 'audio/audia_page.dart';
import 'screens/root_app.dart';
import 'theme/color.dart';
import 'signin_signup/login.dart';
import 'signin_signup/signup.dart';
import 'signin_signup/update.dart';
import 'screens/track.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Course App',
      theme: ThemeData(
        primaryColor: primary,
      ),
      //home: RootApp(),
      routes: {
        "/": (BuildContext context) {
          return const Login();
        },
        "/home": (BuildContext context) {
          return const RootApp();
        },
        "/Signup": (BuildContext context) {
          return const Signup();
        },"/music": (BuildContext context) {
          return const MusicHome();
        },
        "/Track": (BuildContext context) {
          return const Track();
        },
        "/TrackH": (BuildContext context) {
          return const TrackHome();
        },
        "/AudioPage": (BuildContext context) {
          return const AudioPage();
        },
        "/THome": (BuildContext context) {
          return const MyTrackHome();
        },

        "/update": (BuildContext context) {
          return const UpdateUser();
        },

      },
    );
  }

}