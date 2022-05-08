import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_course/screens/drum.dart';
import 'package:online_course/screens/musicProject_home.dart';
import 'package:online_course/screens/piano.dart';
import 'package:online_course/screens/services/sampler.dart';
import 'package:online_course/screens/track_home.dart';
import 'package:online_course/screens/track_office.dart';
import 'package:online_course/signin_signup/update.dart';

import 'screens/home_screen/home_screen.dart';
import 'tuner/tunerHome.dart';
import 'screens/root_app.dart';
import 'theme/color.dart';
import 'signin_signup/login.dart';
import 'signin_signup/signup.dart';
import 'signin_signup/update.dart';
import 'screens/track.dart';
import 'screens/splashScreen.dart';
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
          return SplashScreen();
        },
        "/login": (BuildContext context) {
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

        "/THome": (BuildContext context) {
          return const MyTrackHome();
        },

        "/update": (BuildContext context) {
          return const UpdateUser();
        },
        "/trackoffice": (BuildContext context) {
          return const MyTrackHome();
        },
        "/homescreen": (BuildContext context) {
      return  HomeScreen();
        },
        "/drum": (BuildContext context) {
      return  Drum();
        },
        "/tuner": (BuildContext context) {
          return  TunerHome();
        },
        "/piano": (BuildContext context) {
          return  FlutterPianoScreen();
        },
      },
    );
  }

}