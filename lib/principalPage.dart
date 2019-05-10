import 'package:flutter/material.dart';

import 'package:lynight/profilUtilisateur/profilUtilisateur.dart';
import 'package:lynight/searchBar/bar.dart';
import 'package:lynight/discoverPage/topClubCard.dart';
import 'package:lynight/discoverPage/bottomClubCard.dart';

class PrincipalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrincipalPageState();
  }
}

class _PrincipalPageState extends State<PrincipalPage> {

  String appBarTitle = 'DÉCOUVRIR';



  Widget bottomNavigation() {
    return Container(
      color: Colors.white,
      child: TabBar(
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
        body: TabBarView(children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                TopClubCard(),
                bottomClubCard(),
              ],
            ),
          ),
          SearchBar(),
          UserProfil(),
        ]),
        appBar: AppBar(
          title: Text(
            'DÉCOUVRIR',
            style:
                TextStyle(color: Colors.deepOrange, fontFamily: 'Montserrat',fontSize: 34.0,fontWeight: FontWeight.w500),
          ),
          iconTheme: IconThemeData(
            color: Colors.deepOrange
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SafeArea(
                //permet de ne pas display sous la bar de notif des tels
                child: ListTile(
                  title: Text('DRAWER TO DO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
