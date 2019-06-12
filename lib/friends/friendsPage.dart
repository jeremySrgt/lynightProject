import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lynight/friends/friendResearch.dart';

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
  String currentUserId = 'userId';
  String currentUserMail = 'userMail';
  Map<dynamic, dynamic> currentUserDataMap;
  String _userName = '';


  List<Map<dynamic, dynamic>> listOfRequest = [];
  List<dynamic> userFriendRequestListFromFirestore = [];

  List<Map<dynamic, dynamic>> friendListMap = [];

  CrudMethods crudObj = new CrudMethods();

//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  RefreshController _refreshController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    widget.auth.currentUser().then((id) {
      setState(() {
        currentUserId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        currentUserMail = mail;
      });
    });

//    crudObj.getDataFromUserFromDocument().then((value) {
//      Map<String, dynamic> dataMap = value.data;
//      setState(() {
//        currentUserDataMap = dataMap;
//      });
//
//      List<dynamic> userFriendRequestList = currentUserDataMap['friendRequest'];
//      setState(() {
//        _userName = currentUserDataMap['name'];
//        userFriendRequestListFromFirestore = userFriendRequestList;
//      });
//
//      print('aaaaaaaaaaa');
//      print(userFriendRequestList);
//
//      List<Map<dynamic, dynamic>> tempList = [];
//      tempList.length = userFriendRequestList.length;
//      for (int i = 0; i < userFriendRequestList.length; i++) {
//        print('bbbbbbb-------$i');
//        print(userFriendRequestList[i]);
//        crudObj
//            .getDataFromUserFromDocumentWithID(userFriendRequestList[i])
//            .then((value) {
//          Map<dynamic, dynamic> userDataMap = value.data;
//          print('USERDATAMAP');
//          print(userDataMap);
//          print('IIIIIIIII = $i');
//          tempList.removeAt(i);
//          tempList.insert(i, {
//            'name': userDataMap['name'],
//            'mail': userDataMap['mail'],
//            'ID': userFriendRequestList[i],
//            'friendList': userDataMap['friendList']
//          });
//          setState(() {
//            print(tempList);
//            listOfRequest = tempList;
//          });
//        });
//      }
//    });
  }


  Widget friendRequest() {
    //penser à ajouter un bouton poour supprimer la demande !
    print('early');
    print(userFriendRequestListFromFirestore);
    print('listofrequest');
    print('list' + listOfRequest.toString());
    List<dynamic> mutableListOfRequest = List.from(listOfRequest);
    if (mutableListOfRequest.isEmpty) {
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
                    mutableListOfRequest[i]['friendList']);
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
      mutableFriendListOfDemander.add(currentUserId);
      crudObj.updateData('user', iDDemander, {
        'friendList': mutableFriendListOfDemander
      }); //ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    } else {
      crudObj.updateData('user', iDDemander, {
        'friendList': [currentUserId]
      }); //ajout dans la liste d'amis de l'utilisatuer qui a demandé en ami
    }

    if (currentUserDataMap['friendList'] != null) {
      List<dynamic> mutableFriendListOfCurrentUser =
          List.from(currentUserDataMap['friendList']);
      mutableFriendListOfCurrentUser.add(iDDemander);
      crudObj.updateData('user', currentUserId, {
        'friendList': mutableFriendListOfCurrentUser
      }); //ajout dans la liste d'amis du current user
      crudObj.updateData('user', currentUserId,
          {'friendRequest': userFriendRequestListFromFirestore});
    } else {
      crudObj.updateData('user', currentUserId, {
        'friendList': [iDDemander]
      }); //ajout dans la liste d'amis du current user
      crudObj.updateData('user', currentUserId,
          {'friendRequest': userFriendRequestListFromFirestore});
    }
    _refresh();
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

//      Map<String, dynamic> dataMap = value.data;
      List<Map<dynamic, dynamic>> mutableListOfFriendData = [];
      List<dynamic> tempFriendLList = dataMap['friendList'];
      if (tempFriendLList.isEmpty) {
        setState(() {
          friendListMap = [];
        });
      }
      for (int i = 0; i < tempFriendLList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendLList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          mutableListOfFriendData.add(userDataMap);
          setState(() {
            friendListMap = mutableListOfFriendData;
          });
        });
      }

      _refreshController.refreshCompleted();
    });
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onLoading() {
    return crudObj.getDataFromUserFromDocument().then((value) {
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

//      Map<String, dynamic> dataMap = value.data;
      List<Map<dynamic, dynamic>> mutableListOfFriendData = [];
      List<dynamic> tempFriendLList = dataMap['friendList'];
      if (tempFriendLList.isEmpty) {
        setState(() {
          friendListMap = [];
        });
      }
      for (int i = 0; i < tempFriendLList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendLList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          mutableListOfFriendData.add(userDataMap);
          setState(() {
            friendListMap = mutableListOfFriendData;
          });
        });
      }

      _refreshController.loadComplete();
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
        title: Text(
          'Amis',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          distance: 200.0,
        ),
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                FriendResearch(userName: _userName,currentUserId: currentUserId),
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
