import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopClubCard extends StatelessWidget {
  List<Widget> clubCardList(AsyncSnapshot snapshot, BuildContext context) {
    return snapshot.data.documents.map<Widget>((document) {
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
                    child: Image.asset(
                      './assets/boite.jpg',
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
                    Navigator.pushNamed(context, '/nightClubProfile');
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
                                  document['name'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(document['description']),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(top: 50.0),
                                child: FlatButton(
                                  child: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/nightClubProfile');
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
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance.collection("club").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView(
                scrollDirection: Axis.horizontal,
                children: clubCardList(snapshot,context),
              );
          }
        },
      ),
    );
  }
}
