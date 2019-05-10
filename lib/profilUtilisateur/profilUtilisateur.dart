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
          height: 320,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
                bottomLeft: Radius.circular(32)),
          ),
          child: Column(
            children: <Widget>[
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
                    backgroundImage: ExactAssetImage('assets/test.jpg'),
                    minRadius: 30,
                    maxRadius: 90,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Pseudo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Date de naissance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.music_note,
                color: Colors.orange,
              ),
              Text(
                'Style de musique :',
                style: TextStyle(),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.mail,
                color: Colors.orange,
              ),
              Text(
                'Adresse Mail :',
                style: TextStyle(),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.orange,
              ),
              Text(
                'Téléphone :',
                style: TextStyle(),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
