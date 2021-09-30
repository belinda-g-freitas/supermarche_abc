import 'package:flutter/material.dart';
import 'package:supermarche_abc/pages/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String appName = 'ABC Supermaket';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Register(/*userLanguage: _language, themeName: th*/),
    );
  }
}
