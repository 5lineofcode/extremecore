import 'package:extremecore/view/_debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await autoLogin();
  runApp(MyApp());
}

Future autoLogin() async {
  ExtremeCore().init();

  Session.host = "http://192.168.43.82/sajiweb";

  var url = Session.apiUrl + "/custom/auth/login";
  print("Login: $url");
  await dio.post(url, data: {
    "email": "uzumaki@mailinator.com",
    "password": "101",
  });
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
