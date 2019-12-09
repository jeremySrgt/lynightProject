import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';

class FavoritesNightClub extends StatefulWidget {

  FavoritesNightClub({this.onSignOut});

  final BaseAuth auth = new Auth();
  final VoidCallback onSignOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _FavoritesNightClubState();
  }
}

class _FavoritesNightClubState extends State<FavoritesNightClub> {
  String userId = 'userId';
  String userMail = 'userMail';
  CrudMethods crudObj = new CrudMethods();
  Map<String, dynamic> data;

  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
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
              fontWeight: FontWeight.bold,
            )),
        subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.music_note,
                color: Colors.blue,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: 150),
                    child: Text(
                      "${music['electro'] == true ? 'Électro  ' : ''}${music['populaire'] == true ? 'Populaire  ' : ''}${music['rap'] == true ? 'Rap  ' : ''}${music['rnb'] == true ? 'RnB  ' : ''}${music['rock'] == true ? 'Rock  ' : ''}${music['trans'] == true ? 'Trance  ' : ''}",
                      style: TextStyle(color: Colors.white, height: 1.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
              padding:
                  EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 1),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Mes Favoris',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
      ),
      body: StreamBuilder(
        stream:
        Firestore.instance.collection('user').document(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var userData = snapshot.data;
          return favoritesList(userData);
        },
      ),
      drawer: CustomSlider(userMail: userMail, signOut: widget.onSignOut, activePage: 'Favoris'),
    );
  }
}
