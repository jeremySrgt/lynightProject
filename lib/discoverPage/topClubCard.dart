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
  List<DocumentSnapshot> dataClubFromBDD;

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
    crudObj.getData('club').then((results) {
      setState(() {
        club = results;
      });
    });

    crudObj.getDataFromClubFromDocument().then((value) {
      // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      setState(() {
        dataClubFromBDD = value.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: clubList(),
    );
  }

//  test(){
//    setState(() {
//      AlgoMusicReference algoTest = new AlgoMusicReference(mapOfUserMusics: widget.musicMap, snapClub: dataClubFromBDD);
//      clubSelected = algoTest.compareMusic();
//    });
//  }

  Widget clubList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    //test();
    //print('qsdklqjsmdlksqjdmlkqjmdklqj');
    //print(dataClubFromBDD);
    print('CLUBSLEECT');
    print(clubSelected);

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

                    Map<String, dynamic> clubDataMap;

                    String currentClubId =
                        snapshot.data.documents[i].documentID;
                    clubDataMap = snapshot.data.documents[i].data;
                    Map<dynamic, dynamic> musicMap = clubDataMap['musics'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => NightClubProfile(documentID:currentClubId)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20,bottom: 20 ,right: 20),
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
                        width: width/1.7,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 22.0, right: 22),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11.0),
                                  child: Image.network(
                                    clubDataMap['pictures'][0],
                                    fit: BoxFit.cover,
                                    height: height/6,
                                    width: width/1.3,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height/40,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 32.0, right: 25),
                                child: Text(
                                  snapshot.data.documents[i].data['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: font*20,
                                    color: Colors.white,),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                height: height/40,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: width/40,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${snapshot.data.documents[i].data['arrond']}e arrondissement',
                                          style: TextStyle(
                                            color: Colors.white,
                                            height: 1.2,
                                            fontWeight: FontWeight.bold,
                                              fontSize: font*13
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              SizedBox(
                                height: height/75,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20.0, right: 25),
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.music_note,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: width/40,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      musicMap['electro'] == true
                                          ? Text(
                                        'Electro ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                      musicMap['populaire'] == true
                                          ? Text(
                                        'Populaire ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                      musicMap['rap'] == true
                                          ? Text(
                                        'Rap ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                      musicMap['rnb'] == true
                                          ? Text(
                                        'RnB ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                      musicMap['rock'] == true
                                          ? Text(
                                        'Rock ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                      musicMap['trans'] == true
                                          ? Text(
                                        'Psytrans ',
                                        style:
                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: font*13),
                                        overflow: TextOverflow.visible,
                                      )
                                          : Container(),
                                    ],
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
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
