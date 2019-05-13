import 'package:flutter/material.dart';

class UserProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.3,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
                bottomLeft: Radius.circular(32)),
          ),
          child: Column(
            children: <Widget>[
              Divider(), // saut de ligne
              Divider(),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centrer les icones et l'image sur la page
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    // Bouton pour les modifications
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute()),
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
                    backgroundImage: ExactAssetImage('assets/nightClub.jpg'),
                    minRadius: 30,
                    maxRadius: 70,
                  ),
                  FlatButton(
                    // Bouton pour les paramètres
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThirdRoute()),
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
                    Text(
                      'Pseudo',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text(
            "Style de musique",
            style: TextStyle(color: Colors.orange, fontSize: 18.0),
          ),
          subtitle: Text(
            "Electro, Rap,...",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.mail),
          title: Text(
            "Email",
            style: TextStyle(color: Colors.orange, fontSize: 18.0),
          ),
          subtitle: Text(
            "exemple@gmail.com",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(
            "Numéro",
            style: TextStyle(color: Colors.orange, fontSize: 18.0),
          ),
          subtitle: Text(
            "0101010101",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text(
            "Date de naissance",
            style: TextStyle(color: Colors.orange, fontSize: 18.0),
          ),
          subtitle: Text(
            "01/01/1991",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ],
    ));
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifications"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person, color: Colors.orange,),
            title: TextField(
              decoration: InputDecoration(
                hintText: "NOM Prénom",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.music_note, color: Colors.orange,),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Style de musique",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.orange,),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.orange,),
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
                  color: Colors.orange,
                ),
                Text("Sauvegarder",style: TextStyle(fontSize: 15.0)
                )
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
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Mon profil'),
          ),
        ],
      ),
    );
  }
}
