import 'package:flutter/material.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NightClubProfile extends StatelessWidget {
  NightClubProfile({this.documentID});

  final String documentID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('club')
          .document(documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var clubData = snapshot.data;
        return pageConstruct(clubData, context);
      },
    );
  }

  Widget pageConstruct(clubData, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(clubData['name']),
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
                  infoSection(clubData, context),
                  //priceSection,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget infoSection(clubData, context) {
    return Expanded(
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
                    clubData['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
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
                        clubData['adress'],
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
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
                        clubData['phone'],
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
                        Icons.insert_link,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        clubData['siteUrl'],
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
                    width: 375,
                    padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                    child: Text(
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
                        '   Style de Musique ',
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
                        clubData['soundcloud'],
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                          //key:  Key('register'),
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
  }
}