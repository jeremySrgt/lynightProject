import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/services/userData.dart';

class CustomSlider extends StatelessWidget{
  final String userMail;
  Function signOut;
  final String nameFirstPage;
  final String routeFirstPage;
  final String nameSecondPage;
  final String routeSecondPage;
  final String nameThirdPage;
  final String routeThirdPage;

  CrudMethods crudObj = new CrudMethods();
  UserData userData = new UserData(
    name: "jerem",
    surname: "surget",
    dob: DateTime.utc(1998,4,3),
    favorites: ["boiteID1","boiteID2"],
    mail: "blabla@gmail.com",
    music: ["electro","populaire"],
    notification: true,
    phone: "0659534318",
    picture: "lien vers profilpicture",
    reservation: {"boiteID":"CXeFDsER3","date":"ici un timestamp normalement"},
    sex: true
  );



  void _testCreateUserData() async {
    crudObj.createUserData(userData.getDataMap());
  }

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
                ),
              ],
            ),
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.deepOrange))),
          ),
          FlatButton(
              onPressed: _testCreateUserData,
              child: Text('test create user info', style: TextStyle(fontSize: 14.0, color: Colors.black))
          ),
          ListTile(
            title: Text(nameFirstPage),
            onTap: () {
              Navigator.pushReplacementNamed(context, routeFirstPage);
            },
          ),
          ListTile(
            title: Text(nameSecondPage),
            onTap: () {
              Navigator.pushReplacementNamed(context, routeSecondPage);
            },
          ),
          ListTile(
            title: Text(nameThirdPage),
            onTap: () {
              Navigator.pushReplacementNamed(context, routeThirdPage);
            },
          ),
        ],
      ),
    );
  }
}


