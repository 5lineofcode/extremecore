import 'package:extremecore/view/_debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core.dart';

void main() async {

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saji Apps',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DebugPage(),
    );
  }
}
