import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:simple_slider/simple_slider.dart';
import 'package:lynight/nightCubPage/carousel.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/nightCubPage/sumUpPage.dart';
import 'package:lynight/services/crud.dart';

class NightClubProfile extends StatefulWidget {
  NightClubProfile({this.documentID});

  final String documentID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NightClubProfile();
  }
}

class _NightClubProfile extends State<NightClubProfile> {
  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();

  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;
  bool alreadySaved = false;

  List favorites;

  void initState() {
    super.initState();

    crudObj.getDataFromUserFromDocument().then((value) {
      // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      Map<String, dynamic> dataMap = value
          .data; // retourne la Map des donné de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
      List<dynamic> favoritesAll = dataMap['favoris'];
      setState(() {
        favorites = dataMap['favoris'];
        alreadySaved = favorites.contains(widget.documentID);
      });
    });
  }

  addFavorites() {
    List favoritesListTemp = new List.from(favorites);
    favoritesListTemp.add(widget.documentID);
    Map<String, dynamic> test = {
      'favoris': favoritesListTemp,
    };
    crudObj.createOrUpdateUserData(test);
  }

  removeFavorites() {
    List favoritesListTemp = new List.from(favorites);
    favoritesListTemp.remove(widget.documentID);
    Map<String, dynamic> test = {
      'favoris': favoritesListTemp,
    };
    crudObj.createOrUpdateUserData(test);
  }

  Widget favoriteButton() {
    return Container(
      width: 60,
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.red,
        ),
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              removeFavorites();
              alreadySaved = false;
            } else {
              addFavorites();
              alreadySaved = true;
            }
          });
        },
      ),
    );
  }

  Widget carouselPictureNightClubProfile(clubData, context) {
    var length = clubData['pictures'].length;
    List<String> urlTab = [];
    //i<= 3 pour eviter de charger plus que 4 images de la base
    for (int i = 0; i < length && i <= 3; i++) {
      urlTab.insert(i, clubData['pictures'][i]);
    }
    return Container(
      height: 230,
      width: double.infinity,
      child: PageView(
        children: <Widget>[
          ImageSliderWidget(
            imageUrls: urlTab,
            imageBorderRadius: BorderRadius.circular(8.0),
          ),
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget nightClubProfileInfo(clubData, context) {
    Map<dynamic, dynamic> musicMap = clubData['musics'];

    final linkUrlWebsite = Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0),
      height: 60,
      width: 250,
      child: Text(
        clubData['siteUrl'] + '\n' + '\n' + clubData['soundcloud'],
      ),
    );

    Widget nightClubDescription() {
      return Container(
        alignment: FractionalOffset.center,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          margin: EdgeInsets.only(top: 10),
          height: 100,
          width: 350,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: Icon(
                    Icons.description,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                VerticalDivider(),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  height: 100,
                  width: 250,
                  child: Text(
                    clubData['description'],

                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget nightClubMusic() {
      return Container(
        alignment: FractionalOffset.center,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          margin: EdgeInsets.only(top: 10),
          height: 100,
          width: 350,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: FractionalOffset.center,
                  width: 60,
                  child: Icon(
                    Icons.music_note,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                VerticalDivider(),
                Container(
                  alignment: FractionalOffset.center,
                  height: 60,
                  color: Colors.white10,
                  width: 270,
                  child: Row(
                    children: <Widget>[
                      musicMap['electro'] == true
                          ? Text('Electro ')
                          : Container(),
                      musicMap['populaire'] == true
                          ? Text('Populaire ')
                          : Container(),
                      musicMap['rap'] == true ? Text('Rap ') : Container(),
                      musicMap['rnb'] == true ? Text('RnB ') : Container(),
                      musicMap['rock'] == true ? Text('Rock ') : Container(),
                      musicMap['trans'] == true
                          ? Text('Psytrance ')
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget nightClubInformation() {
      return Container(
        alignment: FractionalOffset.center,
        height: 110,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          margin: EdgeInsets.only(top: 10),
          height: 100,
          width: 350,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: FractionalOffset.center,
                  width: 60,
                  child: Icon(
                    Icons.contacts,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                VerticalDivider(),
                Container(
                    alignment: FractionalOffset.centerLeft,
                    height: 60,
                    color: Colors.white10,
                    width: 270,
                    child: Text(
                        clubData['adress'] + '\n' + '\n' + clubData['phone'])),
              ],
            ),
          ),
        ),
      );
    }

    Widget nightClubLink() {
      return Container(
        alignment: FractionalOffset.center,
        height: 95,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          margin: EdgeInsets.only(top: 10),
          height: 100,
          width: 350,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: FractionalOffset.center,
                  width: 60,
                  child: Icon(
                    Icons.link,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                VerticalDivider(),
                Container(
                  alignment: FractionalOffset.center,
                  margin: EdgeInsets.only(top: 5.0),
                  height: 60,
                  color: Colors.white10,
                  width: 270,
                  child: Row(
                    children: <Widget>[
                      linkUrlWebsite,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget nightClubLetsParty() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            favoriteButton(),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text('Let\'s Party',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              color: Theme.of(context).primaryColor,
              textColor: Colors.black87,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SumUp(
                              clubName: clubData['name'],
                            )));
              },
            ),
            //onPressed: validateAndSubmit),
          ],
        ),
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                nightClubDescription(),
                SizedBox(height: 10),
                nightClubMusic(),
                SizedBox(height: 10),
                nightClubInformation(),
                SizedBox(height: 10),
                nightClubLink(),
                SizedBox(height: 10),
                nightClubLetsParty(),
                SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pageConstruct(clubData, context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(clubData['name']),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.deepPurple[50],
                      Colors.deepPurple[200],
                      Colors.deepPurple[400],
                      Color(0xFF7854d3),
                    ],
                  )),
                  child: Column(
                    children: <Widget>[
                      carouselPictureNightClubProfile(clubData, context),
                      nightClubProfileInfo(clubData, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('club')
          .document(widget.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var clubData = snapshot.data;
        return pageConstruct(clubData, context);
      },
    );
  }
}
