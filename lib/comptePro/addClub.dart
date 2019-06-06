import 'package:flutter/material.dart';
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
  String _phone;
  int _manPrice;
  int _womanPrice;
  String _siteUrl;
  double _latitude;
  double _longitude;

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
        musics: {},
        pictures: [
          'https://firebasestorage.googleapis.com/v0/b/lynight-53310.appspot.com/o/clubPics%2F4alZYX7jcPfAGOT8YmsB%2Fbridge2.png?alt=media&token=d0597141-de82-495d-be98-2f31df827b59'
        ],
        position: GeoPoint(_latitude, _longitude),
        storagePath: '',
        searchKey: _name.substring(0, 1).toUpperCase(),
      );

      crudObj.addData('club', clubData.getClubDataMap());
      setState(() {
        _isLoading = false;
      });
    } else {
//      setState(() {
//        _authHint = '';
//      });
    }
  }

  Widget submitWidget(){
    return PrimaryButton(
      key: new Key('submitclub'),
      text: 'Créer',
      height: 44.0,
      onPressed: validateAndSubmit,
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
            Icons.mail,
            color: Colors.grey,
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
            Icons.mail,
            color: Colors.grey,
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
            Icons.mail,
            color: Colors.grey,
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

  Widget _clubPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        key: new Key('clubPhone'),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Téléphone',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
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

  Widget _clubMusicCheckbox() {}

  Widget _clubPictures() {}

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
                Icons.mail,
                color: Colors.grey,
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
                Icons.mail,
                color: Colors.grey,
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
                Icons.mail,
                color: Colors.grey,
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
                Icons.mail,
                color: Colors.grey,
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
            Icons.mail,
            color: Colors.grey,
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
          _clubNameField(),
          _clubDescription(),
          _clubPhone(),
          _clubAdress(),
          _clubPosition(),
          _clubPrice(),
          _clubSiteUrl(),
          _isLoading == false ? submitWidget() : _showCircularProgress()
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Ajouter un club'),
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
