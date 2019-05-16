import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget{
  final String userMail;
  Function signOut;
  final String nameFirstPage;
  final String routeFirstPage;
  final String nameSecondPage;
  final String routeSecondPage;
  final String nameThirdPage;
  final String routeThirdPage;

  CustomSlider({this.userMail,this.signOut,this.nameFirstPage,this.routeFirstPage,this.nameSecondPage,this.routeSecondPage,this.nameThirdPage,this.routeThirdPage});

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
                    onPressed: signOut,
                    child: Text('Déconnexion', style: TextStyle(fontSize: 14.0, color: Colors.black))
                )
              ],
            ),
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.deepOrange))),
          ),
          ListTile(
            title: Text(nameFirstPage),
            onTap: () {
              Navigator.pushNamed(context, routeFirstPage);
            },
          ),
          ListTile(
            title: Text(nameSecondPage),
            onTap: () {
              Navigator.pushNamed(context, routeSecondPage);
            },
          ),
          ListTile(
            title: Text(nameThirdPage),
            onTap: () {
              Navigator.pushNamed(context, routeThirdPage);
            },
          ),
        ],
      ),
    );
  }
}


