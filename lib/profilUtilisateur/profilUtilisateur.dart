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
            bottomRight: Radius.circular(32),
            bottomLeft: Radius.circular(32)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondRoute()),
                      );
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
                    backgroundImage:
                    ExactAssetImage('assets/nightClub.jpg'),
                    minRadius: 30,
                    maxRadius: 70,
                  ),
                ),
                Container(
                  child: FlatButton(
                    // Bouton pour les paramètres
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThirdRoute()),
                      );
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
/*          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // Centrer les icones et l'image sur la page
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                // Bouton pour les modifications
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondRoute()),
                  );
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
              CircleAvatar(
                // photo de profil
                backgroundImage:
                ExactAssetImage('assets/nightClub.jpg'),
                minRadius: 30,
                maxRadius: 70,
              ),
              FlatButton(
                // Bouton pour les paramètres
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThirdRoute()),
                  );
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
            ],
          ),
          Container(
            // description de la personne
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'NOM Prénom',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget userBottomSection(){

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.music_note),
                      Text(
                        "Style de musique",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(''),
                          Text('Musique 1 \n'),
                          Text('Musique 2 \n'),
                          Text('Musique 3 '),
                        ],
                      ),
                    ],

                  ),

                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.mail),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18.0),
                      ),
                      Text(
                        "exemple@gmail.com",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),

                Container(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.phone),
                        Text(
                          "Numéro",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0),
                        ),
                        Text(
                          "0101010101",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    )

                ),

                Container(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.music_note),
                        Text(
                          "Date de naissance",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0),
                        ),
                        Text(
                          "01/01/1991",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    )

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

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30),
          ),
          ListTile(
            title: Text(
              "Modifications",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).accentColor,
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "NOM Prénom",
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.music_note,
              color: Theme.of(context).accentColor,
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Style de musique",
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.email,
              color: Theme.of(context).accentColor,
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Theme.of(context).accentColor,
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Téléphone",
              ),
            ),
          ),
          FlatButton(
            // Bouton pour la sauvegarde
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.save,
                  size: 35.0,
                  color: Theme.of(context).accentColor,
                ),
                Text("Sauvegarder", style: TextStyle(fontSize: 15.0))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30),
          ),
          ListTile(
            title: Text(
              "Paramètres",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30.0),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Retour'),
          ),
        ],
      ),
    );
  }
}