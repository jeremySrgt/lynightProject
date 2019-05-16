import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomClubCard extends StatelessWidget {
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
                    style: TextStyle(fontSize: 23.0),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection("club").snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: smallClubCardList(snapshot, context),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
