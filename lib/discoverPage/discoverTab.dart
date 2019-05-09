import 'package:flutter/material.dart';

import './topClubCard.dart';
import './bottomClubCard.dart';
import 'package:lynight/searchBar/bar.dart';

class DiscoverTab extends StatelessWidget {
  final scaffoldKey = GlobalKey<
      ScaffoldState>(); //permet de passer le context au scaffold pour l'ouvrir avec le button de notre choix

  Widget topOfThePage(){
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState.openDrawer(); //capte pas comment ca fonctionne mais bon
          },
        ),
        Text(
          'Découvrir',
          style: TextStyle(fontSize: 40.0,fontFamily: 'Montserrat',fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget bottomOfThePage(){
    return BottomNavigationBar(
      items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.adjust),
        title: Text(''),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(''),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text(''),
      ),
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            topOfThePage(),
            SizedBox(
              height: 20.0,
            ),
            topClubCard(),
            bottomClubCard(),
          ],
        ),
      ),
      bottomNavigationBar: bottomOfThePage(),
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
    );
  }
}
