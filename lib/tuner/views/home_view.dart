import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/tuner/extensions/tuner_extension.dart';
import "package:online_course/tuner/widgets/tuner.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocProvider(
            create: (context) => TunerBloc(),
            child: Tuner(),
          ),
        ],
      ),
    );
  }
}
