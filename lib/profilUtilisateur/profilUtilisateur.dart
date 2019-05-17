import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';

class UserProfil extends StatefulWidget {
  UserProfil({this.auth, this.onSignOut});

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
    return _UserProfilState();
  }
}

class _UserProfilState extends State<UserProfil> {
  Widget userInfoTopSection() {
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

  Widget userBottomSection() {
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
                    "exemple@gmail.com",
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
                    "0101010101",
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
                    "01/01/1991",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSlider(
        userMail: 'mail',
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
            title: Text('NOM Prénom'),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            children: <Widget>[
              userInfoTopSection(),
              userBottomSection(),
            ],
          ),
        ),
      ]),
    );
  }
}
