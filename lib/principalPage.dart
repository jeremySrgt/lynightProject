import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lynight/searchBar/dataSearch.dart';
import 'package:tutorial_coach_mark/target_position.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:lynight/widgets/tutorial_focus.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({this.auth, this.onSignOut, this.userId});

  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userId;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _PrincipalPageState();
  }
}

class _PrincipalPageState extends State<PrincipalPage>
    with TickerProviderStateMixin {
  String mail = 'userMail';
//  TabController _controller;

  List<TargetFocus> targets = List();

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();

  Widget appBarTitle = new Text(
    "Découvrir",
    style: TextStyle(
        color: Color(0xFF7854d3), fontSize: 30.0, fontWeight: FontWeight.w500),
  );

  Icon actionIcon = new Icon(
    Icons.search,
    color: Color(0xFF7854d3),
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  CrudMethods crudObj = new CrudMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Map<dynamic, dynamic> mapOfUserMusic;

  void initState() {
    super.initState();
    _IsSearching = false;
    //grace a ca principalPage s'occupe de recuperer les informations de l'utilisateur actif - peut etre pas le meilleur choix mais ca fonctionne
    widget.auth.userEmail().then((userMail) {
      setState(() {
        mail = userMail;
      });
    });

    crudObj.getDataFromUserFromDocument().then((value) {
      Map<dynamic, dynamic> userMap = value.data;
      Map<dynamic, dynamic> userMusic = userMap['music'];
      setState(() {
        mapOfUserMusic = userMusic;
      });
    });

    _firebaseMessaging.getToken().then((token) {
      print(token);
      crudObj.createOrUpdateUserData({"tokenNotif": token});
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        print(notification);
        print(notification['title']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );

    //juste pour IOS
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    TutorialFocus tuto = new TutorialFocus(key1: keyButton, key2: keyButton2, key3: keyButton3);
    tuto.initTutorialClass();

    targets = tuto.getTargetList();


    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  void showTutorial() {
    TutorialCoachMark(
        context,
        targets: targets, // List<TargetFocus>
        colorShadow: Theme.of(context).primaryColor, // DEFAULT Colors.black
//         alignSkip: Alignment.bottomRight,
         textSkip: "Passer le tuto",
//         paddingFocus: 10,
         opacityShadow: 0.9,
        finish: (){
          print("finish");
        },
        clickTarget: (target){
          print(target);
        },
        clickSkip: (){
          print("skip");
        }
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      //evite que les widgets remonte dû à l'apparition du clavier
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height / 35,
            ),
            TopClubCard(musicMap: mapOfUserMusic, widgetKey : keyButton),
            BottomClubCard(musicMap: mapOfUserMusic, widgetKey : keyButton2),
            SizedBox(
              height: height / 35,
            )
          ],
        ),
      ),
      appBar: buildBar(context),
      drawer: CustomSlider(
        userMail: mail,
        signOut: widget._signOut,
        activePage: 'Accueil',
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: false,
        title: appBarTitle,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, key: keyButton3,),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ]);
  }
}
