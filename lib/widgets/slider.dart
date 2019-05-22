import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/services/userData.dart';

class CustomSlider extends StatelessWidget {
  final String userMail;
  Function signOut;
  final String activePage;

  CrudMethods crudObj = new CrudMethods();


  CustomSlider({this.userMail, this.signOut, this.activePage});

  Widget header(context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text('U'),
            ),
            title: Text('userName'),
            subtitle: Text(userMail),
          ),
          RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFFef0000),
              ),
            ),
            color: Color(0xFFffb2b2),
            textColor: Theme.of(context).primaryColor,
            onPressed: signOut,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColor))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          header(context),
          Container(
            decoration: activePage == 'Accueil'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: activePage == 'Accueil'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Accueil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activePage == 'Accueil'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          Container(
            decoration: activePage == 'Profil'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: activePage == 'Profil'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activePage == 'Profil'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/userProfil');
              },
            ),
          ),
          Container(
            decoration: activePage == 'Reservations'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.book,
                color: activePage == 'Reservations'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Réservations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activePage == 'Reservations'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/myReservations');
              },
            ),
          ),
          Container(
            decoration: activePage == 'Maps'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.streetview,
                color: activePage == 'Maps'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Carte',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activePage == 'Maps'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/maps');
              },
            ),
          ),
        ],
      ),
    );
  }
}
