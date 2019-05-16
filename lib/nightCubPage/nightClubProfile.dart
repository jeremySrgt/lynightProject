import 'package:flutter/material.dart';
import 'package:lynight/authentification/primary_button.dart';

class NightClubProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Widget infoSection = Expanded(
      child: Row(
        children: [
          Flexible(

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //met dans le bon axe
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 40,
                  child: Text(
                    'Informations\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
                  child: Text(
                    'Kelly Kelly NightClub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(55, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.place,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '   Paris 13ème ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(55, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      Text(
                        '   0101010010',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(55, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.insert_link,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '   www.kellyKelly.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                    child:
                    Text(
                      'Du mercredi au samedi, de 23h à 6h du matin, nous vous proposons : ®strip-teases, lap dance et shows privés.',
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 50,
                  child: Text(
                    'Musique\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.music_note,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      Text(
                        '   Style de Musique : Electro',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.queue_music,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '   www.soundcloud.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PrimaryButton(
                          key: new Key('register'),
                          text: 'Let\'s Party',
                          height: 44.0),
                      //onPressed: validateAndSubmit),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );



      // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Kelly Kelly nightClub'),
              background: Image.asset(
                'assets/nightClub.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  infoSection,
                  //priceSection,
                ],
              ),
            ),
          )
        ],
      ),
    );

  }
}
