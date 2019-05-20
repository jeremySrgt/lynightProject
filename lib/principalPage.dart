import 'package:flutter/material.dart';

import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';
import 'package:lynight/maps/googleMapsClient.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/myReservations/myReservation.dart';
import 'package:lynight/favorites/favoritesNightClub.dart';
import 'package:lynight/searchBar/searchBar.dart';
import 'package:lynight/favorites/favoritesNightClub.dart';
class PrincipalPage extends StatefulWidget {
  PrincipalPage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

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
      color: Colors.white,
      child: TabBar(
          controller: _controller,
          unselectedLabelColor: Colors.black,
          labelColor: Theme.of(context).primaryColor,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(Icons.adjust),
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
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: bottomNavigation(),
          body: TabBarView(controller: _controller, children: [
            SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
//                  Test(),
                  TopClubCard(),
                  BottomClubCard(),
                ],
              ),
            ),
            SearchBar(),
            FavoritesNightClub(),
          ]),
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Montserrat',
                  fontSize: 34.0,
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
          )),
    );
  }
}
