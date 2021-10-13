import 'package:flutter/material.dart';
import 'package:supermarche_abc/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String appName = 'Supermaché ABC';
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      //darkTheme: ThemeData(primarySwatch: Colors.blueGrey),
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('You have an error ${snapshot.error.toString()}');
            return Text('Il y a eu un problème.');
          } else if (snapshot.hasData) {
            return Register();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
