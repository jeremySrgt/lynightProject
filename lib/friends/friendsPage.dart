import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<dynamic,dynamic> currentUserDataMap;
  String _userName= '';

  String _friendID;
  List<dynamic> _friendRequestList0fRequestedFriend;
  bool _alreadyRequestedFriend = false;

  List<Map<dynamic, dynamic>> listOfRequest = [];

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

    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        currentUserDataMap = dataMap;
      });

      List<dynamic> userFriendRequestList = currentUserDataMap['friendRequest'];
      setState(() {
      _userName = currentUserDataMap['name'];
      });

      for (int i = 0; i < userFriendRequestList.length; i++) {
        crudObj.getDataFromUserFromDocumentWithID(userFriendRequestList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          setState(() {
            listOfRequest.add(
                {'name': userDataMap['name'], 'mail': userDataMap['mail'],'ID': userFriendRequestList[i],'friendList': userDataMap['friendList']});
          });
        });
      }
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
            _userName == null ? Text('Tu dois enregistrer ton nom pour ajouter des amis !'): PrimaryButton(
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

  Widget friendRequest() {//penser à ajouter un bouton poour supprimer la demande !
    //ne pas oublier de suprimer de la liste des request le demander une fois ajouté
    return ListView.builder(
      itemCount: listOfRequest.length,
      itemBuilder: (context, i) {
        print(listOfRequest);
        return Container(
          child: ListTile(
            title: Text(listOfRequest[i]['mail']),
            subtitle: Text(listOfRequest[i]['name']),
            trailing: InkWell(
              child: Icon(FontAwesomeIcons.check),
              onTap: (){
                addFriend(listOfRequest[i]['ID'],listOfRequest[i][friendList]);
              },
            ),
          ),
        );
      },
    );
  }

  void addFriend(iDDemander,friendListOfDemander){

    if(friendListOfDemander !=null){
      List<dynamic> mutableFriendListOfDemander = List.from(friendListOfDemander);
      mutableFriendListOfDemander.add(currenUserId);
      crudObj.updateData('user', iDDemander, {'friendList': mutableFriendListOfDemander});//ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    }else{
      crudObj.updateData('user', iDDemander, {'friendList': [currenUserId]});//ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    }

    if(currentUserDataMap['friendList'] != null){
      List<dynamic> mutableFriendListOfCurrentUser = List.from(currentUserDataMap['friendList']);
      mutableFriendListOfCurrentUser.add(iDDemander);
      crudObj.updateData('user', currenUserId, {'friendList': mutableFriendListOfCurrentUser});//ajout dans la liste d'amis du current user
    }
    else{
      crudObj.updateData('user', currenUserId, {'friendList': [iDDemander]});//ajout dans la liste d'amis du current user
    }

  }

  Widget friendList() {//peut etre un streambuilder, ne causera pas les soucis de friend request je pense
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
              Container(
                height: 300,
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: friendRequest(), // streambuilder pour sure
              ),
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
