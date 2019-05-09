import 'package:flutter/material.dart';

class UserProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget personSection = Container( // description de la personne
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

            ),
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
            color: Colors.orange,
          ),
          Text(
            'Style de musique :',
            style: TextStyle(

            ),
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
            color: Colors.orange,
          ),
          Text(
            'Adresse Mail :',
            style: TextStyle(

            ),
          )

        ],
      ),
    );

    return Column(
            children: [
              Image.asset(
                'assets/boite.jpg',
                width: 220,
                height: 308,
                fit: BoxFit.cover,
              ),
              personSection,
              styleSection,
              infoSection
            ],
          );
  }

}

