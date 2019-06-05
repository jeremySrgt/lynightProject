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

  Column _createFavoritesCard(picture, titre, music, clubID) {
    return Column(children: [
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Image.network(
            picture,
            fit: BoxFit.cover,
            width: 60.0,
            height: 60.0,
          ),
        ),
        title: Text(titre,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
        subtitle: Row(children: <Widget>[
          Icon(
            Icons.music_note,
            color: Colors.blue,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              music['electro'] == true ? Text('Electro ', style: TextStyle(color: Colors.white),) : Container(),
              music['populaire'] == true ? Text('Populaire ', style: TextStyle(color: Colors.white),) : Container(),
              music['rap'] == true ? Text('Rap ', style: TextStyle(color: Colors.white),) : Container(),
              music['rnb'] == true ? Text('RnB ', style: TextStyle(color: Colors.white),) : Container(),
              music['rock'] == true ? Text('Rock ', style: TextStyle(color: Colors.white),) : Container(),
              music['trans'] == true ? Text('Psytrans ', style: TextStyle(color: Colors.white),) : Container(),
            ],
          )
        ]),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NightClubProfile(
                        documentID: clubID,
                      )));
        },
      ),
    ]);
  }

  Card _makeCard(picture, titre, music, clubID) {
    return Card(
      color: Colors.transparent,
      elevation: 12.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        height: 100,
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
        child: Center(
          child: Container(
              height: 80,
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 2.0, bottom: 1),
              child: _createFavoritesCard(picture, titre, music, clubID)),
        ),
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
        return _makeCard(snapshot.data['pictures'][0], snapshot.data['name'],
            snapshot.data['musics'], clubID);
      },
    );
  }

  Widget favoritesList(userData) {
    if (userData['favoris'].length <= 0) {
      return Container(
        child: Center(
          child: Text("Pas de fav bg"),
        ),
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
