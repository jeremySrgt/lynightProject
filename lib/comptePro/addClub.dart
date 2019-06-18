import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/services/clubData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClub extends StatefulWidget {
  AddClub({this.onSignOut});

  final VoidCallback onSignOut;

  BaseAuth auth = new Auth();

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
    // TODO: implement createState
    return _AddClubState();
  }
}

class _AddClubState extends State<AddClub> {
  String userMail = 'userMail';
  String userId = 'userId';

  static final formKey = new GlobalKey<FormState>();
  CrudMethods crudObj = new CrudMethods();

  bool _isLoading = false;

  String _name;
  String _description;
  String _adress;
  int _arrond;
  String _phone;
  int _manPrice;
  int _womanPrice;
  String _siteUrl;
  double _latitude;
  double _longitude;
  List<File> clubPictureFile = new List<File>(4);
  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;

  @override
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      ClubData clubData = new ClubData(
        name: _name,
        description: _description,
        adress: _adress,
        phone: _phone,
        price: [_manPrice, _womanPrice],
        siteUrl: _siteUrl,
        availablePlaces: 100,
        entryNumber: 0,
        like: 0,
        musics: {
          'electro': electro,
          'populaire': populaire,
          'rap': rap,
          'rnb': rnb,
          'rock': rock,
          'trans': trans,
        },
        pictures: [],
        position: GeoPoint(_latitude, _longitude),
        storagePath: '',
        searchKey: _name.substring(0, 1).toUpperCase(),
        arrond: _arrond,
      );

      DocumentReference docRef = await Firestore.instance
          .collection('club')
          .add(clubData.getClubDataMap());
      uploadPictures(docRef.documentID);

//      setState(() {
//        _isLoading = false;
//      });

    } else {
//      setState(() {
//        _authHint = '';
//      });
    }
  }

  Widget submitWidget() {
    return PrimaryButton(
        key: new Key('submitclub'),
        text: 'Créer',
        height: 44.0,
        onPressed: () {
          if (clubPictureFile[0] == null) {
            validateAndSave();
            _showDialogMissingPhoto();
          } else if (!electro &&
              !rap &&
              !rock &&
              !rnb &&
              !trans &&
              !populaire) {
            validateAndSave();
            _showDialogMissingMusicStyle();
          } else {
            validateAndSubmit();
          }
        });
  }

  void _showDialogMissingPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Photo manquante"),
          content: new Text(
            "Au moins une photo est requise pour ajouter un club",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogMissingMusicStyle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("N'oubliez pas le style de musique"),
          content: new Text(
            "Dans le but de mieux reférencer votre club nous vous invitons à saisir au moins 1 style de musique",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _clubNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('clubName'),
        decoration: InputDecoration(
          labelText: 'Nom du club',
          icon: new Icon(
            FontAwesomeIcons.solidMoon,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un nom';
          }
        },
        onSaved: (value) => _name = value,
      ),
    );
  }

  Widget _clubDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLength: 200,
        key: new Key('clubDescription'),
        decoration: InputDecoration(
          labelText: 'Decription',
          icon: new Icon(
            FontAwesomeIcons.solidClipboard,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une description';
          }
        },
        onSaved: (value) => _description = value,
      ),
    );
  }

  Widget _clubAdress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        key: new Key('clubAdress'),
        decoration: InputDecoration(
          labelText: 'Adresse',
          icon: new Icon(
            FontAwesomeIcons.mapMarkerAlt,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez une adresse';
          }
        },
        onSaved: (value) => _adress = value,
      ),
    );
  }

  Widget _clubArrond() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        key: new Key('clubArrond'),
        decoration: InputDecoration(
          labelText: 'Arrondissement',
          icon: new Icon(
            FontAwesomeIcons.compass,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        //on laisse l'arrondissement optionnel, si pas d'arrondissement, on affiche l'adresse sur la page d'acceuil
//        validator: (String value) {
//          if (value.isEmpty) {
//            return 'Saisissez une adresse';
//          }
//        },
        onSaved: (value) => _arrond = int.parse(value),
      ),
    );
  }

  Widget _clubPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        key: new Key('clubPhone'),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Téléphone',
          icon: new Icon(
            FontAwesomeIcons.phone,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un numéro';
          }
        },
        onSaved: (value) => _phone = value,
      ),
    );
  }

  //----------------------------------------------------------------------------------------------

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.grey[600]),
        ),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            switch (title) {
              case "electro":
                setState(() {
                  electro = value;
                });
                break;
              case "rap":
                setState(() {
                  rap = value;
                });
                break;
              case "rnb":
                setState(() {
                  rnb = value;
                });
                break;
              case "populaire":
                setState(() {
                  populaire = value;
                });
                break;
              case "rock":
                setState(() {
                  rock = value;
                });
                break;
              case "psytrance":
                setState(() {
                  trans = value;
                });
                break;
            }
          },
        )
      ],
    );
  }

  Widget _checkboxMusicStyle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Style de musique de la boite',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              checkbox('electro', electro),
              SizedBox(
                width: 20,
              ),
              checkbox('populaire', populaire),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              checkbox('rap', rap),
              SizedBox(
                width: 20,
              ),
              checkbox('rnb', rnb),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              checkbox('rock', rock),
              SizedBox(
                width: 20,
              ),
              checkbox('psytrance', trans),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------------------------

  //peut etre toruver un moyen de convertir les adress en coordonnées satelite
  Widget _clubPosition() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            key: new Key('clubPositionLat'),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Latitude',
              icon: new Icon(
                FontAwesomeIcons.mapPin,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Saisissez une latitude';
              }
            },
            onSaved: (value) => _latitude = double.parse(value),
          ),
          TextFormField(
            key: new Key('clubPositionLon'),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Longitude',
              icon: new Icon(
                FontAwesomeIcons.mapPin,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Saisissez une longitude';
              }
            },
            onSaved: (value) => _longitude = double.parse(value),
          ),
        ],
      ),
    );
  }

  Widget _clubPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            key: new Key('clubPriceMan'),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Prix homme',
              icon: new Icon(
                FontAwesomeIcons.euroSign,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Saisissez un prix';
              }
            },
            onSaved: (value) => _manPrice = int.parse(value),
          ),
          TextFormField(
            key: new Key('clubPriceWoman'),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Prix femme',
              icon: new Icon(
                FontAwesomeIcons.euroSign,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Saisissez un prix';
              }
            },
            onSaved: (value) => _womanPrice = int.parse(value),
          ),
        ],
      ),
    );
  }

  Widget _clubSiteUrl() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        key: new Key('clubUrl'),
        decoration: InputDecoration(
          labelText: 'Site web [optionnel]',
          icon: new Icon(
            FontAwesomeIcons.link,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        //pas de validator car le site web est optionnel
//        validator: (String value) {
//          if (value.isEmpty) {
//            return 'Saisissez un numéro';
//          }
//        },
        onSaved: (value) => _siteUrl = value,
      ),
    );
  }

  Widget _selectionPictures() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: Container(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: clubPictureFile.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              key: Key('pic$index'),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[300]),
                  margin: EdgeInsets.only(right: 10),
                  width: 250,
                  height: 200,
                  child: clubPictureFile[index] == null
                      ? FlatButton(
                          onPressed: () {
                            getImageFromGallery(index);
                          },
                          child: Icon(Icons.add_circle_outline),
                        )
                      : InkWell(
                          onTap: () {
                            getImageFromGallery(index);
                          },
                          child: Image.file(
                            clubPictureFile[index],
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Text(
                  'Photo ${index + 1}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future getImageFromGallery(picNumber) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (picNumber == 0) {
      setState(() {
        clubPictureFile[0] = tempImage;
      });
    }
    if (picNumber == 1) {
      setState(() {
        clubPictureFile[1] = tempImage;
      });
    }
    if (picNumber == 2) {
      setState(() {
        clubPictureFile[2] = tempImage;
      });
    }
    if (picNumber == 3) {
      setState(() {
        clubPictureFile[3] = tempImage;
      });
    }
  }

  uploadPictures(clubID) async {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    var rnd = new Random();
    List<String> urlList = [];
    for (int i = 0; i < clubPictureFile.length; i++) {
      if (clubPictureFile[i] != null) {
        final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('clubPics/$clubID/$i.jpg');
        final StorageUploadTask task =
            firebaseStorageRef.putFile(clubPictureFile[i]);
//      if (task.isInProgress) {
//        setState(() {
//          _isLoading = true;
//        });
//      }
        var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
        var url = downloadUrl.toString();
        urlList.add(url);
      }
    }
    setState(() {
      _isLoading = false;
    });
    updateCLubPictures(urlList, clubID);
  }

  updateCLubPictures(picUrlList, clubID) {
    Firestore.instance
        .collection('club')
        .document(clubID)
        .updateData({"pictures": picUrlList});
    Navigator.pushReplacementNamed(context,
        "/"); // comme cette methode est apl a la toute fin du processus de creation on push la cpage d'acceuil depuis cette methode pour etre sur que le process soit fini
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showCircularProgress() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0, 5.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                _clubNameField(),
                _clubDescription(),
                Container(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0, 5.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                _clubPhone(),
                _clubAdress(),
                _clubArrond(),
                _clubPosition(),
                Container(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0, 5.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                _clubPrice(),
                Container(
                  height: 15,
                ),
              ],
            ),
          ),
          _selectionPictures(),
          Container(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0, 5.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                _checkboxMusicStyle(),
                _clubSiteUrl(),

                Container(
                  height: 15,
                ),
              ],
            ),

          ),
          _isLoading == false ? submitWidget() : _showCircularProgress(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'Ajouter un club',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                child: buildForm(),
              ),
            ]),
          ]),
        ),
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'AddClub',
      ),
    );
  }
}
