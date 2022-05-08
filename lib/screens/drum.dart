import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_course/screens/services/sampler.dart';
import 'package:online_course/screens/views/display.dart';

import 'package:online_course/screens/views/sequencer.dart';
import 'package:online_course/screens/views/transport.dart';
import 'package:online_course/screens/views/pad-bank.dart';



void drum() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Sampler.init();

}

class Drum extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return
         Scaffold(
           appBar: AppBar(
             title: const Text('Drum Machine'),
             backgroundColor: Colors.deepOrange,
           ),

          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Display(),
                Sequencer(),
                Transport(),
                PadBank()
              ]
          ),
         );

  }
}
