import 'package:flutter/material.dart';

class UserProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16),
          width: 500,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
                bottomLeft: Radius.circular(32)),
          ),
          child: Column(
            children: <Widget>[
              Divider(),
              Divider(),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centrer les icones et l'image sur la page
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.mode_edit,
                          size: 35.0,
                          color: Colors.white,
                        ),
                        Text("Modification")
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/nightClub.jpg'),
                    minRadius: 30,
                    maxRadius: 50,
                  ),
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          size: 35.0,
                          color: Colors.white,
                        ),
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
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      'Date de naissance',
                      style: TextStyle(fontSize: 15.0),
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
      ],
    ));
  }
}
