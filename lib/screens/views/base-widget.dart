import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_course/screens/services/audio-engine.dart';

class BaseWidget extends StatefulWidget {
	
	BaseWidget({ key: Key }) : super(key: key);

	@override
	BaseState createState() => BaseState();
}

class BaseState<T extends BaseWidget> extends State<T> {

	late StreamSubscription<Signal> _stream;

	void on<Signal>(Signal s) => setState(() => null);

	@override
	void initState() {
		
		_stream = AudioEngine.listen(on);
		super.initState();
	}
	
	@override
	void dispose() {

		if (_stream != null) { _stream.cancel(); }
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Container();
}
