import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
class BottomClubCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomClubCardState();
  }

}

class _BottomClubCardState extends State<BottomClubCard>{

  CrudMethods crudObj = new CrudMethods();
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

  List<Widget> smallClubCardList(AsyncSnapshot snapshot, BuildContext context) {
    return snapshot.data.documents.map<Widget>((document) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/nightClubProfile');
            },
            child: Card(
              elevation: 8.0,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0)),
                    child: Image.asset(
                      './assets/boite.jpg',
                      fit: BoxFit.cover,
                      height: 115,
                      width: 120.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      document['name'],
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
    }).toList();
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
    if(club != null){
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
                itemBuilder: (context,i){

                  Map<String,dynamic> clubDataMap;

                  String currentClubId = snapshot.data.documents[i].documentID;
                  clubDataMap = snapshot.data.documents[i].data;

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
                                  snapshot.data.documents[i].data['name'],
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
