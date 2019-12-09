import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';
import 'package:lynight/maps/googleMapsClient.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/myReservations/myReservation.dart';
import 'package:lynight/favorites/favoritesNightClub.dart';
import 'package:lynight/searchBar/searchBar.dart';
import 'package:lynight/favorites/favoritesNightClub.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({this.auth, this.onSignOut, this.userId, this.admin});

  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userId;
  final bool admin;

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
  String appBarTitle = 'Découvrir';

  String mail = 'userMail';

  TabController _controller;

  CrudMethods crudObj = new CrudMethods();
  Map<dynamic, dynamic> mapOfUserMusic;

  //TODO changer la couleur de l'appbar en focntion de la couleur de l'element en dessous - ca fait plus joli
  //TODO par exemple dans le profil utilisateur c'est flagrant

  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener(_handleSelected);
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

  void _handleSelected() {
    setState(() {
      if (_controller.index == 0) {
        appBarTitle = 'Découvrir';
      }
      if (_controller.index == 1) {
        appBarTitle = 'Recherche';
      }
      if (_controller.index == 2) {
        appBarTitle = 'Favoris';
      }
    });
  }

  Widget bottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(212, 63, 141, 1),
              Color.fromRGBO(2, 80, 197, 1)
            ]),
        //color: Theme.of(context).primaryColor,
      ),
      child: TabBar(
          controller: _controller,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(FontAwesomeIcons.globe),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.favorite),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
//        bottomNavigationBar: bottomNavigation(),
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

//        TabBarView(controller: _controller, children: [
//          SafeArea(
//            child: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: height/35,
//                ),
//                TopClubCard(musicMap: mapOfUserMusic),
//                BottomClubCard(musicMap: mapOfUserMusic),
//                SizedBox(
//                  height: height/35,
//                )
//              ],
//            ),
//          ),
//          SearchBar(),
//          FavoritesNightClub(),
//        ]),
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        drawer: CustomSlider(
          userMail: mail,
          signOut: widget._signOut,
          activePage: 'Accueil',
        ),
      ),
    );
  }
}
