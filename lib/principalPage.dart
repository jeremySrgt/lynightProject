import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lynight/profilUtilisateur/profilUtilisateur.dart';
import 'package:lynight/searchBar/bar.dart';
import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';
import 'package:lynight/maps/googleMapsClient.dart';
import 'package:lynight/authentification/auth.dart';



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

  TabController _controller;
  //TODO changer la couleur de l'appbar en focntion de la couleur de l'element en dessous - ca fait plus joli
  //TODO par exemple dans le profil utilisateur c'est flagrant

  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener(_handleSelected);
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
          labelColor: Colors.deepOrange,
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
                TopClubCard(),
                BottomClubCard(),
              ],
            ),
          ),
          SearchBar(),
          GoogleMapsClient(),
        ]),
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'Montserrat',
                fontSize: 34.0,
                fontWeight: FontWeight.w500),
          ),
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('nom utilisateur'),
                    ),
                    FlatButton(
                        onPressed: widget._signOut,
                        child: Text('Déconnexion', style: TextStyle(fontSize: 14.0, color: Colors.black))
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.deepOrange))),
              ),
              //permet de ne pas display sous la bar de notif des tels
              ListTile(
                title: Text('Profil'),
                onTap: () {
                  Navigator.pushNamed(context, '/userProfil');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
