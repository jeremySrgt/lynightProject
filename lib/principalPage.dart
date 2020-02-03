import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/searchBar/searchBar.dart';

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
    // TODO: implement createState
    return _PrincipalPageState();
  }
}

class _PrincipalPageState extends State<PrincipalPage>
    with TickerProviderStateMixin {

  String mail = 'userMail';

//  TabController _controller;

  Widget appBarTitle = new Text(
    "Découvrir",
    style: TextStyle(
        color: Color(0xFF7854d3),
        fontSize: 30.0,
        fontWeight: FontWeight.w500),
  );

  Icon actionIcon = new Icon(Icons.search, color: Color(0xFF7854d3),);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

//  _PrincipalPageState() {
//    _searchQuery.addListener(() {
//      if (_searchQuery.text.isEmpty) {
//        setState(() {
//          _IsSearching = false;
//          _searchText = "";
//        });
//      }
//      else {
//        setState(() {
//          _IsSearching = true;
//          _searchText = _searchQuery.text;
//        });
//      }
//    });
//  }


  CrudMethods crudObj = new CrudMethods();
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false, //evite que les widgets remonte dû à l'apparition du clavier
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height / 35,
            ),
            TopClubCard(musicMap: mapOfUserMusic),
            BottomClubCard(musicMap: mapOfUserMusic),
            SizedBox(
              height: height / 35,
            )
          ],
        ),
      ),
//La recherhce trouver un meilleur moyen de l'intégrer et les queries pour rechercher les boites (peut etre avec algolia
      //pour les favoris rajouter un onglet dans le slider pour permettre d'alléger la page principale

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
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Theme.of(context).primaryColor,);
                this.appBarTitle = new TextField(
                  autofocus: true,
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor,

                  ),
                  decoration: new InputDecoration(
                    border: InputBorder.none,
//                      prefixIcon: new Icon(Icons.search, color: Theme.of(context).primaryColor),
                      hintText: "Recherche...",
                      hintStyle: new TextStyle(color: Theme.of(context).primaryColor)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }
  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Theme.of(context).primaryColor,);
      this.appBarTitle =
      new Text(
        "Découvrir",
        style: TextStyle(
            color: Color(0xFF7854d3),
            fontSize: 30.0,
            fontWeight: FontWeight.w500),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}
