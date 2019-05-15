import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget{
  final String userMail;
  Function _signOut;

  CustomSlider(this.userMail,this._signOut);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(userMail),
                ),
                FlatButton(
                    onPressed: _signOut,
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
    );
  }
}


