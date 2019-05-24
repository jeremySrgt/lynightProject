import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/services/crud.dart';

class FavoritesNightClub extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavoritesNightClubState();
  }
}

class _FavoritesNightClubState extends State<FavoritesNightClub> {
  String userId = 'userId';

  CrudMethods crudObj = new CrudMethods();

  Map<String, dynamic> data;

  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
  }

  ListTile _createFavoritesCard(titre, music, clubID) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
        )),
        child: Icon(Icons.music_note, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        titre,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Text(music),
                ],
              ),
            ),
          )
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 25.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NightClubProfile(
                      documentID: clubID,
                    )));
      },
    );
  }

  Card makeCard(titre, music, clubID) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: _createFavoritesCard(titre, music, clubID),
      ),
    );
  }

  Widget _clubList(clubID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('club').document(clubID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        for (int i = 0; i < snapshot.data['music'].length; i++) {
          return makeCard(
              snapshot.data['name'],
              snapshot.data['music'][i],
              clubID);
        }
      },
    );
  }

  Widget favoritesList(userData) {
    if (userData['favoris'].length <= 0) {
      return Container(
        child: Text("Pas de fav bg"),
      );
    } else {
      return Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: userData['favoris'].length,
          itemBuilder: (BuildContext context, int index) {
            return _clubList(userData['favoris'][index]);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('user').document(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var userData = snapshot.data;
        return favoritesList(userData);
      },
    );
  }
}
