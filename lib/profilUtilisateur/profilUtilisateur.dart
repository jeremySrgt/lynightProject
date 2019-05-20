import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserProfil extends StatefulWidget {
  UserProfil({this.onSignOut});

//  final BaseAuth auth;
  final VoidCallback onSignOut;

  BaseAuth auth = new Auth();
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
    return _UserProfilState();
  }
}

class _UserProfilState extends State<UserProfil> {

  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();
  String userMail = 'userMail';


  void initState() {
    super.initState();
    //grace a ca principalPage s'occupe de recuperer les informations de l'utilisateur actif - peut etre pas le meilleur choix mais ca fonctionne
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('user')
          .document(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userData = snapshot.data;
        return pageConstruct(userData, context);
      },
    );
  }

  Widget userInfoTopSection(userData) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32), bottomLeft: Radius.circular(32)),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Centrer les icones et l'image sur la page
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: FlatButton(
                  // Bouton pour les modifications
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute()),
                      );*/
                  }, // renvoi vers les modifications
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.mode_edit,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      Divider(),
                      Text("Modification")
                    ],
                  ),
                ),
                ),
                Container(
                  child: CircleAvatar(
                    // photo de profil
                    backgroundImage: ExactAssetImage('assets/nightClub.jpg'),
                    minRadius: 30,
                    maxRadius: 70,
                  ),
                ),
                Container(
                  child: FlatButton(
                    // Bouton pour les paramètres
                    onPressed: () {
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThirdRoute()),
                      );*/
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          size: 35.0,
                          color: Colors.white,
                        ),
                        Divider(),
                        Text("Paramètres")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userBottomSection(userData) {
    //DateTime dob = userData['DOB'];
    //String formattedDob = DateFormat('yyyy-MM-dd').format(dob);
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(
                    "Style de musique",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(''),
                      Text('Musique 1 \n'),
                      Text('Musique 2 \n'),
                      Text('Musique 3 '),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(
                    "Email",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    userData['mail'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    "Numéro",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    userData['phone'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(
                    "Date de naissance",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    'Naissance',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 Widget pageConstruct(userData, context){
    return Scaffold(
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        nameFirstPage: 'Accueil',
        routeFirstPage: '/',
        nameSecondPage: 'Mes Réservations',
        routeSecondPage: '/myReservations',
        nameThirdPage: 'Carte',
        routeThirdPage: '/maps',
      ),
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(userData['name'] + ' ' + userData['surname']),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            children: <Widget>[
              userInfoTopSection(userData),
              userBottomSection(userData),
            ],
          ),
        ),
      ]),
    );
 }

}
