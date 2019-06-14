import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/algo/algoReferencementMusique.dart';

class BottomClubCard extends StatefulWidget {
  @override
  final musicMap;

  BottomClubCard({this.musicMap});

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomClubCardState();
  }
}

class _BottomClubCardState extends State<BottomClubCard> {
  CrudMethods crudObj = new CrudMethods();
  Stream club;
  Map<dynamic, dynamic> mapOfUserMusic;
  List<DocumentSnapshot> dataClubFromBDD;
  List<String> clubSelected;

  @override
  void initState() {
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
    super.initState();
  }

  // Méthode qui apelle l'algo en lui donnant la musicMap et une List<DocumentSnapshot>
  algoRecommandation() {
    setState(() {
      AlgoMusicReference algo = new AlgoMusicReference(
          mapOfUserMusics: widget.musicMap, snapClub: dataClubFromBDD);
      clubSelected = algo.compareMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    // TODO: implement build
    return Container(
      height: height / 3,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Recommandé',
                  style: TextStyle(
                      fontSize: font * 25,
                      color: Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
          Expanded(
            child: clubList(),
          ),
        ],
      ),
    );
  }

  Widget clubList() {
    algoRecommandation();
    List displayNightClub = [];
    List displayNightClubID = [];
    if (club != null) {
      return StreamBuilder(
        stream: club,
        builder: (context, snapshot) {
          //print('entrer dans le stream builder ');
          // On cherche sur chaque club et on compare chaque club existant dans la base avec les club retourné de l'algo
          if ((clubSelected) != null && snapshot.data != null) {
            for (int i = 0; i < clubSelected.length; i++) {
              for (int j = 0; j < snapshot.data.documents.length; j++) {
                if (snapshot.data.documents[j].documentID == clubSelected[i]) {
                  displayNightClub.add(snapshot.data.documents[j].data);
                  displayNightClubID.add(snapshot.data.documents[j].documentID);
                }
              }
            }
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                itemCount: displayNightClub.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  double width = MediaQuery.of(context).size.width;
                  double height = MediaQuery.of(context).size.height;
                  double font = MediaQuery.of(context).textScaleFactor;

                  Map<String, dynamic> clubDataMap;

                  String currentClubId = displayNightClubID[
                      i]; //recharge la page avec les recommandé adapté avec l'algo
                  clubDataMap = displayNightClub[i];

                  return Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, top: 20.0, bottom: 10.0, right: 15),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NightClubProfile(
                                      documentID: currentClubId)));
                        },
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(11.0),
                              child: Image.network(
                                clubDataMap['pictures'][0],
                                fit: BoxFit.cover,
                                height: height / 4.5,
                                width: 130.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 5.5, left: 15, right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.black54],
                                  stops: [0.5, 1.0],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  tileMode: TileMode.repeated,
                                )),
                                child: Text(
                                  clubDataMap['name'],
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      );
    } else {
      return ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            double font = MediaQuery.of(context).textScaleFactor;

            return Padding(
              padding: EdgeInsets.only(
                  left: 15.0, top: 20.0, bottom: 10.0, right: 15),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11.0),
                      child: Image(
                        image: AssetImage('./assets/gris_chargement.jpg'),
                        fit: BoxFit.cover,
                        height: height / 4.5,
                        width: 130.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height / 10, left: 45,),
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
