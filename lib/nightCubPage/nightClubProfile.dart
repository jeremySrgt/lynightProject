import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:simple_slider/simple_slider.dart';
import 'package:lynight/nightCubPage/carousel.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/nightCubPage/sumUpPage.dart';
import 'package:lynight/services/crud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  bool descriptionRoll = false;
  Widget descriptionSubtitle;

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
    if (!favoritesListTemp.contains(widget.documentID)) {
      favoritesListTemp.add(widget.documentID);
    }
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
    return IconButton(
        icon: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.red,
          size: 35,
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
        });
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

    _launchCaller() async {
      var url = "tel:" + clubData['phone'];

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Non disponible $url';
      }
    }

    _launchMap() async {
      var url =
          "google.navigation:q=${clubData['position'].latitude},${clubData['position'].longitude}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Non disponible $url';
      }
    }

    _launchSite() async {
      var url = clubData['siteUrl'];
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Non disponible $url';
      }
    }

    description() {
      return Text(
        clubData['description'],
        style: TextStyle(
          color: Colors.black,
          height: 1.2,
        ),
        textAlign: TextAlign.justify,

      );
    }

    Widget nightClubDescription() {
      return Container(
        child: ListTile(
          leading: Icon(
            Icons.description,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Description",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
          subtitle: descriptionSubtitle,
          trailing: Icon(
              descriptionRoll
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              color: descriptionRoll
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor),
          onTap: () {
            setState(() {
              if (descriptionRoll) {
                descriptionSubtitle = null;
                descriptionRoll = false;
              } else {
                descriptionSubtitle = description();
                descriptionRoll = true;
              }
            });
          },
        ),
      );
    }

    Widget nightClubMusic() {
      return Container(
        child: ListTile(
          leading: Icon(
            Icons.music_note,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Musiques",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              musicMap['electro'] == true
                  ? Text('Electro ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
              musicMap['populaire'] == true
                  ? Text('Populaire ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
              musicMap['rap'] == true
                  ? Text('Rap ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
              musicMap['rnb'] == true
                  ? Text('RnB ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
              musicMap['rock'] == true
                  ? Text('Rock ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
              musicMap['trans'] == true
                  ? Text('Psytrance ', style: TextStyle(color: Colors.black,height: 1.2))
                  : Container(),
            ],
          ),
        ),
      );
    }

    Widget nightClubInformation() {
      return Container(
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.infoCircle,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Informations",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                     'Adresse : ',
                    style: TextStyle(color: Colors.black,height: 1.2),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Text(
                        clubData['adress'],
                        style: TextStyle(color: Colors.black, fontSize: 16,height: 1.2),
                      ),
                      onTap: () {
                        _launchMap();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Téléphone : ',
                    style: TextStyle(color: Colors.black,height: 1.2),
                  ),
                  InkWell(
                    child: Text(
                      clubData['phone'],
                      style: TextStyle(color: Colors.black, fontSize: 16,height: 1.2),
                    ),
                    onTap: () {
                      _launchCaller();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget nightClubLink() {
      return Container(
        child: ListTile(
          leading: Icon(
            FontAwesomeIcons.link,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Liens",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                splashColor: Colors.white,
                child: Text(clubData['siteUrl'],
                    style: TextStyle(color: Colors.black,height: 1.5)),
                onTap: () {
                  _launchSite();
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget nightClubPrice() {
      return Container(
        child: ListTile(
          leading: Icon(
            Icons.monetization_on,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            "Tarifs ",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.male, color: Colors.black, size: 20),
                  Text(
                    'Homme : ' + clubData['price'][0].toString() + " €",
                    style: TextStyle(color: Colors.black,height: 1.5),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.female, color: Colors.black, size: 20),
                  Text(
                    'Femme : ' + clubData['price'][1].toString() + " €",
                    style: TextStyle(color: Colors.black,height: 1.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget nightClubLetsParty() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ],
        ),
      );
    }

    Widget lineSeparator() {
      return Divider(
        color: Theme.of(context).primaryColor,
        height: 15,
        indent: 70,
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      clubData['name'],
                      style: TextStyle(
                          fontSize: 40, color: Theme.of(context).primaryColor),
                    ),
                    favoriteButton(),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                nightClubDescription(),
                lineSeparator(),
                nightClubMusic(),
                lineSeparator(),
                nightClubInformation(),
                lineSeparator(),
                nightClubLink(),
                lineSeparator(),
                nightClubPrice(),
                SizedBox(height: 20),
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
                  /**decoration: BoxDecoration(
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
                      )),**/
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
