import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'principalPage.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/profilUtilisateur/profilUtilisateur.dart';
import 'package:lynight/maps/googleMapsClient.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/authentification/root_page.dart';
import 'package:lynight/myReservations/myReservation.dart';

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
          primaryColor: Colors.redAccent,
          accentColor: Colors.blueGrey[600],
          fontFamily: 'Comfortaa'),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) => RootPage(auth: Auth(),),
//        '/principal': (BuildContext context) => PrincipalPage(),
        '/nightClubProfile': (BuildContext context) => NightClubProfile(),
        '/userProfil': (BuildContext context) => UserProfil(),
        '/myReservations': (BuildContext context) => ListReservation(),
        '/maps': (BuildContext context) => GoogleMapsClient(),


      },
    );
  }
}
