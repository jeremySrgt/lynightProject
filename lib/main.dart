import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'principalPage.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          fontFamily: 'Montserrat'),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) => PrincipalPage(),
        '/nightClubProfile': (BuildContext context) => NightClubProfile(),

      },
    );
  }
}
