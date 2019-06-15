import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lynight/friends/friendResearch.dart';
import 'package:folding_cell/folding_cell.dart';

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
//    print('early');
//    print(userFriendRequestListFromFirestore);
//    print('listofrequest');
//    print('list' + listOfRequest.toString());
    List<dynamic> mutableListOfRequest = List.from(listOfRequest);
    if (mutableListOfRequest.isEmpty) {
      return Text('Aucune demande d\'ami');
    }
    return ListView.builder(
      itemCount: mutableListOfRequest.length,
      itemBuilder: (context, i) {
        return Card(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      // photo de profil
                      backgroundImage:
                          NetworkImage(mutableListOfRequest[i]['picture']),
                      minRadius: 25,
                      maxRadius: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            mutableListOfRequest[i]['name'],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            mutableListOfRequest[i]['mail'],
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  //add
                  child: Icon(FontAwesomeIcons.check),
                  onTap: () {
                    userFriendRequestListFromFirestore =
                        List.from(userFriendRequestListFromFirestore)
                          ..removeAt(i);

                    addFriend(mutableListOfRequest[i]['ID'],
                        mutableListOfRequest[i]['friendList']);
                    setState(() {
                      listOfRequest = List.from(listOfRequest)..removeAt(i);
                    });
                  },
                ),
                InkWell(
                  //remove
                  child: Icon(FontAwesomeIcons.times),
                  onTap: () {
                    userFriendRequestListFromFirestore =
                        List.from(userFriendRequestListFromFirestore)
                          ..removeAt(i);

                    removeFriendRequest();

                    setState(() {
                      listOfRequest = List.from(listOfRequest)..removeAt(i);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeFriendRequest() {
    crudObj.updateData('user', currentUserId,
        {'friendRequest': userFriendRequestListFromFirestore});
  }

  void addFriend(iDDemander, friendListOfDemander) {
//    print('late');
//    print(userFriendRequestListFromFirestore);

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

//  Widget friendList() {
//    if (friendListMap.isEmpty) {
//      return Text('Aucun amis');
//    } else {
//      return ListView.builder(
//        itemCount: friendListMap.length,
//        itemBuilder: (context, i) {
//          return Card(
//            elevation: 3.0,
//            child: ListTile(
//              leading: CircleAvatar(
//                // photo de profil
//                backgroundImage: NetworkImage(friendListMap[i]['picture']),
//                minRadius: 25,
//                maxRadius: 25,
//              ),
//              title: Text(friendListMap[i]['name']),
//              subtitle: Text(friendListMap[i]['mail']),
//            ),
//          );
//        },
//      );
//    }
//  }

  Widget friendList() {
    if (friendListMap.isEmpty) {
      return Text('Aucun amis');
    } else {
      return ListView.builder(
        itemCount: friendListMap.length,
        itemBuilder: (context, i) {
          return SimpleFoldingCell(
            frontWidget: _buildFrontWidget(i),
            innerTopWidget: _buildInnerTopWidget(i),
            innerBottomWidget: _buildInnerBottomWidget(i),
            cellSize: Size(MediaQuery.of(context).size.width, 125),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 14,
            onOpen: () => print('$i cell ouverte'),
            onClose: () => print('$i cell fermée'),
          );
        },
      );
    }
  }

  Widget _buildFrontWidget(int i) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            SimpleFoldingCellState foldingCellState = context
                .ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
            foldingCellState?.toggleFold();
          },
          child: Container(
            color: Color(0xFFdfd3ff),
            alignment: Alignment.center,
            child: ListTile(
              leading: CircleAvatar(
                // photo de profil
                backgroundImage: NetworkImage(friendListMap[i]['picture']),
                minRadius: 25,
                maxRadius: 25,
              ),
              title: Text(friendListMap[i]['name']),
              subtitle: Text(friendListMap[i]['mail']),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInnerTopWidget(int i) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          SimpleFoldingCellState foldingCellState = context
              .ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
          foldingCellState?.toggleFold();
        },
        child: Container(
          color: Color(0xFFecf2f9),
          alignment: Alignment.center,
          child: ListTile(
            leading: CircleAvatar(
              // photo de profil
              backgroundImage: NetworkImage(friendListMap[i]['picture']),
              minRadius: 25,
              maxRadius: 25,
            ),
            title: Text(friendListMap[i]['name']),
            subtitle: Text(friendListMap[i]['mail']),
          ),
        ),
      );
    });
  }

  Widget _buildInnerBottomWidget(int i) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          SimpleFoldingCellState foldingCellState = context
              .ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
          foldingCellState?.toggleFold();
        },
        child: Container(
          color: Color(0xFFecf2f9),
//          alignment: Alignment.center,
          child: _buttonOneFriendCard(),
        ),
      );
    });
  }

  Widget _buttonOneFriendCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  FontAwesomeIcons.handshake,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.transparent,
                    border: Border.all(color: Theme.of(context).primaryColor)),
              ),
              onTap: () {
                print('BUTTON 1');
              },
            ),
            Text('Jsp button'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  FontAwesomeIcons.shareAlt,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.transparent,
                    border: Border.all(color: Theme.of(context).primaryColor)),
              ),
              onTap: () {
                print('BUTTON 2');
              },
            ),
            Text('Inviter'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Colors.red,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red),
                ),
              ),
              onTap: () {
                print('BUTTON 3');
              },
            ),
            Text('Supprimer'),
          ],
        ),
      ],
    );
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

//      print('aaaaaaaaaaa');
//      print(userFriendRequestList);

      List<Map<dynamic, dynamic>> tempList = [];
      tempList.length = userFriendRequestList.length;
      for (int i = 0; i < userFriendRequestList.length; i++) {
//        print('bbbbbbb-------$i');
//        print(userFriendRequestList[i]);
        crudObj
            .getDataFromUserFromDocumentWithID(userFriendRequestList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
//          print('USERDATAMAP');
//          print(userDataMap);
//          print('IIIIIIIII = $i');
          tempList.removeAt(i);
          tempList.insert(i, {
            'name': userDataMap['name'],
            'mail': userDataMap['mail'],
            'ID': userFriendRequestList[i],
            'friendList': userDataMap['friendList'],
            'picture': userDataMap['picture'],
          });
          setState(() {
//            print(tempList);
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

//      print('aaaaaaaaaaa');
//      print(userFriendRequestList);

      List<Map<dynamic, dynamic>> tempList = [];
      tempList.length = userFriendRequestList.length;
      for (int i = 0; i < userFriendRequestList.length; i++) {
//        print('bbbbbbb-------$i');
//        print(userFriendRequestList[i]);
        crudObj
            .getDataFromUserFromDocumentWithID(userFriendRequestList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
//          print('USERDATAMAP');
//          print(userDataMap);
//          print('IIIIIIIII = $i');
          tempList.removeAt(i);
          tempList.insert(i, {
            'name': userDataMap['name'],
            'mail': userDataMap['mail'],
            'ID': userFriendRequestList[i],
            'friendList': userDataMap['friendList'],
            'picture': userDataMap['picture'],
          });
          setState(() {
//            print(tempList);
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
        child: Container(
          child: Column(
            children: <Widget>[
              FriendResearch(userName: _userName, currentUserId: currentUserId),
              // demande à yann pour rechercher par nom - 1ere approche par ID complet
              Container(
                height: 300,
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: friendRequest(), // streambuilder pour sure
              ),
              Container(
                width: 400,
                height: 700,
                child: friendList(),
              ),
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
