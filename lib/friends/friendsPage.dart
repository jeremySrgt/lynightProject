import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({this.onSignOut});

//  final BaseAuth auth;
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
    return _FriendsPageState();
  }
}

//TODO SEPARER LES DIFFERENTES SECTION (research, request et liste) DANS DES DIFFERENTS FICHIER/CLASS POUR PLUS DE CLARTER PCQ CA VA ETRE LE BORDEL SINON

class _FriendsPageState extends State<FriendsPage> {
  String currenUserId = 'userId';
  String currentUserMail = 'userMail';

  String _friendID;
  List<dynamic> _friendRequestList0fRequestedFriend;
  bool _alreadyRequestedFriend = false;

  CrudMethods crudObj = new CrudMethods();
  static final formKey = new GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        currenUserId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        currentUserMail = mail;
      });
    });
  }

  Widget friendResearch() {
    // la section research est pour le moment directement un ajout avec l'ID
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              key: Key('addViaID'),
              decoration: InputDecoration(
                labelText: 'Ajout par ID (ne pas se tromper)',
                icon: new Icon(
                  FontAwesomeIcons.plusCircle,
                  color: Colors.grey,
                ),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Saisis un ID';
                }
              },
              onSaved: (value) => _friendID = value,
            ),
            PrimaryButton(
              key: new Key('submitFriendRequest'),
              text: 'demande d\'ami',
              height: 44.0,
              onPressed: () {
                validateAndSubmit();
                print('friend ID : ' + _friendID);
              },
            ),
            _alreadyRequestedFriend == true
                ? Text(
                    'Une demande d\'ami a déjà été envoyée',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
          ],
        ),
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

  void validateAndSubmit() async {
    //TODO ajouter la submition
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      crudObj.getDataFromUserFromDocumentWithID(_friendID).then((value) {
        Map<String, dynamic> dataMap = value.data;
        List friendRequestList = dataMap['friendRequest'];
        print(friendRequestList);
        if (friendRequestList == null) {
          crudObj.updateData('user', _friendID, {
            'friendRequest': [currenUserId]
          });
        } else {
          setState(() {
            _friendRequestList0fRequestedFriend = friendRequestList;
          });

          for (int i = 0; i < _friendRequestList0fRequestedFriend.length; i++) {
            if (_friendRequestList0fRequestedFriend[i] == currenUserId) {
              setState(() {
                _alreadyRequestedFriend = true;
              });
            }
          }

          if (_alreadyRequestedFriend == false) {
            List<String> mutableListOfRequestedFriend =
                List.from(_friendRequestList0fRequestedFriend);

            mutableListOfRequestedFriend.add(currenUserId);

            crudObj.updateData('user', _friendID,
                {'friendRequest': mutableListOfRequestedFriend});
          }
        }
      });
    }
  }

  Widget friendRequest() {
    return Text('request section');
  }

  Widget friendList() {
    return Text('friend list section');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Amis'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              friendResearch(),
              // demande à yann pour rechercher par nom - 1ere approche par ID complet
              friendRequest(),
              // streambuilder pour sure
              friendList()
              // streambuilder pour sure
            ],
          ),
        ),
      ),
      drawer: CustomSlider(
        userMail: currentUserMail,
        signOut: widget._signOut,
        activePage: 'Amis',
      ),
    );
  }
}
