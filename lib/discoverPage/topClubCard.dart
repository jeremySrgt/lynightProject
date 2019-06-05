import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/algo/algoReferencementMusique.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopClubCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopClubCardState();
  }
}

class _TopClubCardState extends State<TopClubCard> {

  CrudMethods crudObj = new CrudMethods();
  AlgoMusicReference algoTest = new AlgoMusicReference(user: 'AzqV0Q3rcHQiE97XRC8XtGme78y1', mapOfUserMusics: {'populaire': true, 'rap': false, 'rock': true, 'electro': false, 'rnb': false, 'trans': true});
  Stream club;

  @override
  void initState() {
    crudObj.getData('club').then((results) {
      setState(() {
        club = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: clubList(),
    );
  }


  Widget clubList() {
    algoTest.compareMusic();
    if (club != null) {
      return StreamBuilder(
        stream: club,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    Map<String,dynamic> clubDataMap;

                    String currentClubId = snapshot.data.documents[i].documentID;
                    clubDataMap = snapshot.data.documents[i].data;

                    return Container(
                      width: 330.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(11.0),
                                  child: Image.network(
                                    clubDataMap['pictures'][0],
                                    fit: BoxFit.cover,
                                    height: 240.0,
                                    width: 300.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                top: 180.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => NightClubProfile(documentID:currentClubId)));
                                },
                                child: Card(
                                  elevation: 5.0,
                                  child: Container(
                                    width: 250.0,
                                    height: 100.0,
                                    child: Column(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                snapshot.data.documents[i]
                                                    .data['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              subtitle: Text(snapshot
                                                  .data
                                                  .documents[i]
                                                  .data['description']),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              padding:
                                                  EdgeInsets.only(top: 50.0),
                                              child: FlatButton(
                                                child:
                                                    Icon(Icons.chevron_right),
                                                onPressed: () {
                                                  Navigator.push(context,MaterialPageRoute(builder: (context) => NightClubProfile(documentID:currentClubId)));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
          }
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
