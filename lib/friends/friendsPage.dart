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
//TODO peut etre ajouter une verif pour pas ajouter 2 fois un amis qu'on a deja car là la verif se fait sur la list friendRequest, avant de pouvoir demander un ami mais pas sur la liste d'amis en elle meme
//TODO ajuter un message lorsque alreadyRequestedFriend == true pour prevenir le user qu'il a deja demandé en ami le mec

class _FriendsPageState extends State<FriendsPage> {
  String currenUserId = 'userId';
  String currentUserMail = 'userMail';
  Map<dynamic, dynamic> currentUserDataMap;
  String _userName = '';

  String _friendID;
  List<dynamic> _friendRequestList0fRequestedFriend;
  bool _alreadyRequestedFriend = false;

  List<Map<dynamic, dynamic>> listOfRequest = [];
  List<dynamic> userFriendRequestListFromFirestore = [];

  List<Map<dynamic, dynamic>> friendListMap = [];

  CrudMethods crudObj = new CrudMethods();
  static final formKeyAddFriend = new GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
        userFriendRequestListFromFirestore = userFriendRequestList;
      });

      print('aaaaaaaaaaa');
      print(userFriendRequestList);

      List<Map<dynamic, dynamic>> tempList = [];
      tempList.length = userFriendRequestList.length;
      for (int i = 0; i < userFriendRequestList.length; i++) {
        print('bbbbbbb-------$i');
        print(userFriendRequestList[i]);
        crudObj
            .getDataFromUserFromDocumentWithID(userFriendRequestList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          print('USERDATAMAP');
          print(userDataMap);
          print('IIIIIIIII = $i');
          tempList.removeAt(i);
          tempList.insert(i, {
            'name': userDataMap['name'],
            'mail': userDataMap['mail'],
            'ID': userFriendRequestList[i],
            'friendList': userDataMap['friendList']
          });
          setState(() {
            print(tempList);
            listOfRequest = tempList;
          });
        });
      }

      List<Map<dynamic, dynamic>> mutableListOfFriendData = [];
      List<dynamic> tempFriendLList = currentUserDataMap['friendList'];
      for (int i = 0; i < tempFriendLList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendLList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          mutableListOfFriendData.add(userDataMap);
        });
        setState(() {
          friendListMap = mutableListOfFriendData;
        });
      }
    });
  }

  Widget friendResearch() {
    // la section research est pour le moment directement un ajout avec l'ID
    return Container(
      child: Form(
        key: formKeyAddFriend,
        child: Column(
          children: <Widget>[
            TextFormField(
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
            _userName == null
                ? Text('Tu dois enregistrer ton nom pour ajouter des amis !')
                : PrimaryButton(
                    text: 'demande d\'ami',
                    height: 44.0,
                    onPressed: () {
                      validateAndSubmit();
//                print('friend ID : ' + _friendID);
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
    final form = formKeyAddFriend.currentState;
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
    //penser à ajouter un bouton poour supprimer la demande !
    print('early');
    print(userFriendRequestListFromFirestore);
    print('listofrequest');
    print('list' + listOfRequest.toString());
    List<dynamic> mutableListOfRequest = List.from(listOfRequest);
    if(mutableListOfRequest.isEmpty){
      return Text('Aucune demande d\'ami');
    }
    return ListView.builder(
      itemCount: mutableListOfRequest.length,
      itemBuilder: (context, i) {
        return Container(
          child: ListTile(
            title: Text(mutableListOfRequest[i]['mail']),
            subtitle: Text(mutableListOfRequest[i]['name']),
            trailing: InkWell(
              child: Icon(FontAwesomeIcons.check),
              onTap: () {
                userFriendRequestListFromFirestore =
                    List.from(userFriendRequestListFromFirestore)..removeAt(i);

                addFriend(mutableListOfRequest[i]['ID'],
                    mutableListOfRequest[i][friendList]);
                setState(() {
                  listOfRequest = List.from(listOfRequest)..removeAt(i);
                });
              },
            ),
          ),
        );
      },
    );
  }

  void addFriend(iDDemander, friendListOfDemander) {
    print('late');
    print(userFriendRequestListFromFirestore);

    if (friendListOfDemander != null) {
      List<dynamic> mutableFriendListOfDemander =
          List.from(friendListOfDemander);
      mutableFriendListOfDemander.add(currenUserId);
      crudObj.updateData('user', iDDemander, {
        'friendList': mutableFriendListOfDemander
      }); //ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    } else {
      crudObj.updateData('user', iDDemander, {
        'friendList': [currenUserId]
      }); //ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    }

    if (currentUserDataMap['friendList'] != null) {
      List<dynamic> mutableFriendListOfCurrentUser =
          List.from(currentUserDataMap['friendList']);
      mutableFriendListOfCurrentUser.add(iDDemander);
      crudObj.updateData('user', currenUserId, {
        'friendList': mutableFriendListOfCurrentUser
      }); //ajout dans la liste d'amis du current user
      crudObj.updateData('user', currenUserId,
          {'friendRequest': userFriendRequestListFromFirestore});
    } else {
      crudObj.updateData('user', currenUserId, {
        'friendList': [iDDemander]
      }); //ajout dans la liste d'amis du current user
      crudObj.updateData('user', currenUserId,
          {'friendRequest': userFriendRequestListFromFirestore});
    }
  }

  Widget friendList() {
    if (friendListMap.isEmpty) {
      return Text('Aucun amis');
    } else {
      return ListView.builder(
        itemCount: friendListMap.length,
        itemBuilder: (context, i) {
          return Container(
            child: ListTile(
              title: Text(friendListMap[i]['name']),
              subtitle: Text(friendListMap[i]['mail']),
            ),
          );
        },
      );
    }
  }

  Future<dynamic> _refresh() {
    return crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      List<Map<dynamic, dynamic>> mutableListOfFriendData = [];
      List<dynamic> tempFriendLList = dataMap['friendList'];
      for (int i = 0; i < tempFriendLList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendLList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          mutableListOfFriendData.add(userDataMap);
        });
        setState(() {
          friendListMap = mutableListOfFriendData;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('Amis',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 34),),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: SingleChildScrollView(
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
                Container(
                  width: 400,
                  height: 400,
                  child: friendList(),
                ),
                // streambuilder pour sure
              ],
            ),
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
