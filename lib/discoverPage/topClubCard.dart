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
  final musicMap;

  TopClubCard({this.musicMap});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopClubCardState();
  }
}

class _TopClubCardState extends State<TopClubCard> {
  CrudMethods crudObj = new CrudMethods();
  Map<dynamic, dynamic> mapOfUserMusic;
  Stream club;
  Map<dynamic, dynamic> testMap;
  List<String> clubSelected;
  List<Map<dynamic, dynamic>> queryClubList;

  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;

  //AlgoMusicReference algoTest = new AlgoMusicReference();

  @override
  void initState() {
    super.initState();

    crudObj.getDataDocuments('club').then((querySnapshot) {
      //print(querySnapshot.documents[3].documentID);
      List<Map<dynamic, dynamic>> tempList = [];
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        Map<dynamic, dynamic> tempMap = querySnapshot.documents[i].data;
        tempMap['clubID'] = querySnapshot.documents[i].documentID;
        tempList.add(tempMap);
      }

      setState(() {
        queryClubList = tempList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (queryClubList == null) {
      return _loadingState();
    }

    return Expanded(
      child: clubList(),
    );
  }

  Widget clubList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return ListView.builder(
        itemCount: queryClubList.length,
        //faire une verif que la list ne soit pas null pour ca utiliser le refresh peut etre ca pourrait etre sympa
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          Map<dynamic, dynamic> musicMap = queryClubList[i]['musics'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NightClubProfile(
                          documentID: queryClubList[i]['clubID'])));
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
              //alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(212, 63, 141, 1),
                        Color.fromRGBO(2, 80, 197, 1)
                      ]),
                  //color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              width: width / 1.7,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Image.network(
                          queryClubList[i]['pictures'][0],
                          fit: BoxFit.cover,
                          height: height / 6,
                          width: width / 1.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 25),
                      child: Text(
                        queryClubList[i]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: font * 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: width / 40,
                            ),
                            Expanded(
                              child: Text(
                                '${queryClubList[i]['arrond']}e arrondissement',
                                style: TextStyle(
                                    color: Colors.white,
                                    height: 1.2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: height / 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 25),
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.music_note,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: width / 40,
                        ),
                        musicMap['electro'] == true
                            ? Text(
                                'Electro ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        musicMap['populaire'] == true
                            ? Text(
                                'Populaire ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        musicMap['rap'] == true
                            ? Text(
                                'Rap ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        musicMap['rnb'] == true
                            ? Text(
                                'RnB ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        musicMap['rock'] == true
                            ? Text(
                                'Rock ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font * 13),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        Flexible(
                          child: musicMap['trans'] == true
                              ? Text(
                                  'Psytrans ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: font * 13),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _loadingState() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
            //alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: Colors.grey[350],
                //color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            width: width / 1.7,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Image(
                          image: AssetImage('./assets/bloonLogo.png'),
                          fit: BoxFit.contain,
                          height: height / 6,
                          width: width / 1.3,
                        )),
                  ),
                  SizedBox(
                    height: height / 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 95.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
