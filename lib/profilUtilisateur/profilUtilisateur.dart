import 'package:flutter/material.dart';

class UserProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget personSection = Container(
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
            style: TextStyle(),
          ),
          Text(
            'Localisation',
            style: TextStyle(),
          ),
        ],
      ),
    );

    Widget styleSection = Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: Colors.deepOrange,
          ),
          Text(
            'Style de musique :',
            style: TextStyle(),
          )
        ],
      ),
    );

    Widget infoSection = Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Icon(
            Icons.mail,
            color: Colors.deepOrange,
          ),
          Text(
            'Adresse Mail :',
            style: TextStyle(),
          )
        ],
      ),
    );

    Widget phoneSection = Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Icon(
            Icons.phone,
            color: Colors.deepOrange,
          ),
          Text(
            'Portable: :',
            style: TextStyle(),
          )
        ],
      ),
    );

    return Column(
      children: [
        CircleAvatar(
           backgroundImage: ExactAssetImage('assets/test.jpg'),
            minRadius: 90,
            maxRadius: 150,),
        styleSection,
        infoSection,
        phoneSection,
        const RaisedButton(
          onPressed: null,
          child: Text('Modifier mon profil', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}


