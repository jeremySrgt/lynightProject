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

class _BottomClubCardState extends State<BottomClubCard>{

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
    crudObj.getDataFromClubFromDocument().then((value){ // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      setState(() {
        dataClubFromBDD = value.documents;
      });
    });
    super.initState();
  }


  // Méthode qui apelle l'algo en lui donnant la musicMap et une List<DocumentSnapshot>
  test(){
    setState(() {
      AlgoMusicReference algoTest = new AlgoMusicReference(mapOfUserMusics: widget.musicMap, snapClub: dataClubFromBDD);
      clubSelected = algoTest.compareMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SizedBox(
        height: 230.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Recommandé',
                    style: TextStyle(fontSize: 23.0, color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
            Expanded(
              child: clubList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget clubList(){
    test();
    //print('prrrrrrrrrrrrint selected');
    //print(clubSelected);
    List displayNightClub = [];
    List displayNightClubID = [];
    if(club != null){
      return StreamBuilder(
        stream: club,
        builder: (context, snapshot) {
          //print('entrer dans le stream builder ');
          // On cherche sur chaque club et on compare chaque club existant dans la base avec les club retourné de l'algo
          if((clubSelected) != null && snapshot.data !=null) {
            for (int i = 0; i < clubSelected.length; i++) {
              for (int j = 0; j < snapshot.data.documents.length; j++) {
                if (snapshot.data.documents[j].documentID == clubSelected[i]) {
                  displayNightClub.add(snapshot.data.documents[j].data);
                  displayNightClubID.add(snapshot.data.documents[j].documentID);
                }
              }
            }
            //print('La liste de club ::::::');
            //print(displayNightClub.length);
            //print(displayNightClub);

          }
          //print('sortie de la big bpucle');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                itemCount: displayNightClub.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,i){

                  Map<String,dynamic> clubDataMap;

                  String currentClubId = displayNightClubID[i];//recharge la page avec les recommandé adapté avec l'algo
                  clubDataMap = displayNightClub[i];

                  return Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => NightClubProfile(documentID:currentClubId)));
                        },
                        child: Card(
                          elevation: 8.0,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0)),
                                child: Image.network(
                                  clubDataMap['pictures'][0],
                                  fit: BoxFit.cover,
                                  height: 115,
                                  width: 120.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  clubDataMap['name'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      );
    }
    else {
      return CircularProgressIndicator();
    }
  }
}
