import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folding_cell/folding_cell.dart';
import 'dart:math' as math;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:lynight/friends/SearchAlgo.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({this.onSignOut});

//  final BaseAuth auth;
  final VoidCallback onSignOut;

  final BaseAuth auth = new Auth();

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

  List<dynamic> userFriendList = [];

  List<Map<dynamic, dynamic>> friendListMap = [];

  CrudMethods crudObj = new CrudMethods();
  final SlidableController slidableController = SlidableController();

//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  RefreshController _refreshController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);

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
  }

  Widget friendRequest() {
    List<dynamic> mutableListOfRequest = List.from(listOfRequest);

    if (mutableListOfRequest.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Center(
              child: Text('Aucune demande d\'ami'),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
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
                    child: Icon(FontAwesomeIcons.check,color: Colors.green[400],),
                    onTap: () {
                      userFriendRequestListFromFirestore =
                      List.from(userFriendRequestListFromFirestore)
                        ..removeAt(i);

                      addFriend(mutableListOfRequest[i]['ID'],
                          mutableListOfRequest[i]['friendList']);
                      setState(() {
                        listOfRequest = List.from(listOfRequest)
                          ..removeAt(i);
                      });
                    },
                  ),
                  InkWell(
                    //remove
                    child: Icon(FontAwesomeIcons.times,color: Colors.red[400],),
                    onTap: () {
                      userFriendRequestListFromFirestore =
                      List.from(userFriendRequestListFromFirestore)
                        ..removeAt(i);

                      removeFriendRequest();

                      setState(() {
                        listOfRequest = List.from(listOfRequest)
                          ..removeAt(i);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
        childCount: mutableListOfRequest.length,
      ),
    );
  }

  void removeFriendRequest() {
    crudObj.updateData('user', currentUserId,
        {'friendRequest': userFriendRequestListFromFirestore});
  }

  void addFriend(iDDemander, friendListOfDemander) {
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
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Center(
              child: Text('Aucun amis'),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        return Column(
          children: <Widget>[
            Slidable(
              controller: slidableController,
              key: Key(Random().nextInt(1000).toString() +
                  friendListMap[i]['name'].toString()),
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 0.25,
              actions: <Widget>[
                _inviteFriendSlideButton(i),
              ],
              secondaryActions: <Widget>[
                _deleteFriendSlideButton(i),
              ],
              child: _makeCard(i),
            ),
            i == friendListMap.length - 1 ? SizedBox(height: 200.0,) : Container(),
          ],
        );
      }, childCount: friendListMap.length),
    );
  }

  Widget _makeCard(i) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(212, 63, 141, 1),
                Color.fromRGBO(2, 80, 197, 1)
              ]),
          //color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: _makeListTile(i),
      ),
    );
  }

  Widget _makeListTile(i) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: CircleAvatar(
        // photo de profil
        backgroundImage: NetworkImage(friendListMap[i]['picture']),
        minRadius: 25,
        maxRadius: 25,
      ),
      title: Text(
        friendListMap[i]['name'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          friendListMap[i]['mail'], style: TextStyle(color: Colors.white)),
    );
  }

  Widget _deleteFriendSlideButton(i) {
    return IconSlideAction(
      caption: 'Supprimer',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () {
        List<dynamic> mutableFriendList = List.from(userFriendList);
        List<Map<dynamic, dynamic>> mutableFriendListMap =
            friendListMap;
        String friendID = friendListMap[i]['ID'];
//                print('MUTABLEFRIENDLIST AVANT REMOVE');
//                print(mutableFriendList);
//                mutableFriendList = List.from(mutableFriendList)..removeAt(i);
//                print('MUTABLEFRIENDLIST APRES REMOVE');
//                print(mutableFriendList);
        for (int b = 0; b < mutableFriendList.length; b++) {
          if (friendID == mutableFriendList[b]) {
            mutableFriendList.removeAt(b);
          }
        }

        List<dynamic> mutableFriendListOfFriend =
        List.from(friendListMap[i]['friendList']);
        for (int k = 0; k < mutableFriendListOfFriend.length; k++) {
          if (currentUserId == mutableFriendListOfFriend[k]) {
            mutableFriendListOfFriend.removeAt(k);
            break;
          }
        }
        mutableFriendListMap = List.from(mutableFriendListMap)
          ..removeAt(i);

        setState(() {
          userFriendList = mutableFriendList;
          friendListMap = mutableFriendListMap;
        });
        removeFriend(friendID, mutableFriendListOfFriend);
      },
    );
  }

  Widget _inviteFriendSlideButton(i) {
    return IconSlideAction(
      caption: 'Inviter',
      color: Colors.blue,
      icon: FontAwesomeIcons.handshake,
      onTap: () {
        _openModalBottomSheet(
            context, friendListMap[i]['ID'], friendListMap[i]['name']);
      },
    );
  }

  void removeFriend(friendID, friendListOfFriend) {
    crudObj.updateData('user', currentUserId, {'friendList': userFriendList});
    crudObj.updateData('user', friendID, {'friendList': friendListOfFriend});
    _refresh();
  }

  void _openModalBottomSheet(context, friendID, friendName) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF737373)),
                color: Color(0xFF737373),
              ),
              child: Container(
                child: inviteToClub(friendID, friendName),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget inviteToClub(friendID, friendName) {
    List<dynamic> currentUserReservation =
    List.from(currentUserDataMap['reservation']);

    if (currentUserReservation.isEmpty) {
      return Container(
        margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Clique sur un évènement pour inviter $friendName',
                textAlign: TextAlign.center, style: TextStyle(color: Theme
                    .of(context)
                    .primaryColor, fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 150),
              child: Center(child: Text('Aucune réservation en cours',style: TextStyle(color: Colors.black),strutStyle: StrutStyle(fontSize: 25),overflow: TextOverflow.visible,)),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text('Clique sur un évènement pour inviter $friendName',
              textAlign: TextAlign.center, style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 20),),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: currentUserReservation.length,
                itemBuilder: (context, i) {
                  Timestamp reservationDate = currentUserReservation[i]['date'];
                  return Card(
                    child: ListTile(
                      title: Text(currentUserReservation[i]['boiteID']),
                      subtitle: Text(DateFormat('dd/MM/yyyy')
                          .format(reservationDate.toDate())),
                      onTap: () {
                        inviteFriend(
                            _userName,
                            friendID,
                            currentUserReservation[i]['boiteID'],
                            reservationDate,
                            currentUserReservation[i]['qrcode']);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "$friendName a été invité à ${currentUserReservation[i]['boiteID']}"),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void inviteFriend(currentUserName, friendID, boiteName, date, qrCodeUrl) {
    crudObj.getDataFromUserFromDocumentWithID(friendID).then((value) {
      Map<dynamic, dynamic> userDataMap = value.data;
      List<dynamic> invitationList = userDataMap['invitation'];
      if (invitationList != null) {
        List<dynamic> mutableInvitationList = List.from(invitationList);
        mutableInvitationList
            .add({
          'who': currentUserName,
          'boite': boiteName,
          'date': date,
          'qrcode': qrCodeUrl
        });
        crudObj.updateData(
            'user', friendID, {'invitation': mutableInvitationList});
      } else {
        List<Map<dynamic, dynamic>> newListOfInvitation = [
          {
            'who': currentUserName,
            'boite': boiteName,
            'date': date,
            'qrcode': qrCodeUrl
          }
        ];
        crudObj
            .updateData('user', friendID, {'invitation': newListOfInvitation});
      }
    });
  }

  Future<dynamic> _refresh() {
    return crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        currentUserDataMap = dataMap;
      });

      List<dynamic> userFriendRequestList = currentUserDataMap['friendRequest'];
      List<dynamic> currentUserFriendList = currentUserDataMap['friendList'];
      setState(() {
        _userName = currentUserDataMap['name'];
        userFriendRequestListFromFirestore = userFriendRequestList;
        userFriendList = currentUserFriendList;
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
      List<dynamic> tempFriendList = dataMap['friendList'];
      if (tempFriendList.isEmpty) {
        setState(() {
          friendListMap = [];
        });
      }
      for (int i = 0; i < tempFriendList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          userDataMap['ID'] = tempFriendList[i];
          mutableListOfFriendData.add(userDataMap);
          setState(() {
            friendListMap = mutableListOfFriendData;
          });
        });
      }

      _refreshController.refreshCompleted();
    });
  }

  @override
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
      List<dynamic> currentUserFriendList = currentUserDataMap['friendList'];
      setState(() {
        _userName = currentUserDataMap['name'];
        userFriendRequestListFromFirestore = userFriendRequestList;
        userFriendList = currentUserFriendList;
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
      List<dynamic> tempFriendList = dataMap['friendList'];
      if (tempFriendList.isEmpty) {
        setState(() {
          friendListMap = [];
        });
      }
      for (int i = 0; i < tempFriendList.length; i++) {
        crudObj
            .getDataFromUserFromDocumentWithID(tempFriendList[i])
            .then((value) {
          Map<dynamic, dynamic> userDataMap = value.data;
          userDataMap['ID'] = tempFriendList[i];
          mutableListOfFriendData.add(userDataMap);
          setState(() {
            friendListMap = mutableListOfFriendData;
          });
        });
      }

      _refreshController.loadComplete();
    });
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: false,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 70.0,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              headerText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingCollapsed() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0.0),
      child: Center(
        child: ListTile(
          title: Text(
            "Recherche tes amis",
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25.0,),
             textAlign: TextAlign.center,
          ),
          trailing: Icon(Icons.arrow_upward, color: Theme.of(context).primaryColor, size: 30,),
        ),
      ),
    );
  }

  Widget _floatingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
//        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      ),
      margin: const EdgeInsets.all(2.0),
      child: Center(
        child: SearchAlgo(
          currentUserId: currentUserId,
          userName: _userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        // pour éviter l'ombre qui fait moche avec l'animation du refresh
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: Text(
          'Amis',
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor, fontSize: 30),
        ),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: false,
        collapsed: _floatingCollapsed(),
        panel: _floatingPanel(),
        minHeight: 65,
        maxHeight: 400,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        onPanelClosed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              color: Colors.white,
              distance: 200.0,
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            onRefresh: _refresh,

            child: CustomScrollView(
              slivers: <Widget>[
//                  makeHeader('Recherche tes amis !'),
//                  _showFriendResearch(),
                makeHeader('Demande d\'amis'),
                friendRequest(),
                makeHeader('Liste d\'amis'),
                friendList(),
              ],
            )),
      ),
      drawer: CustomSlider(
        userMail: currentUserMail,
        signOut: widget._signOut,
        activePage: 'Amis',
      ),
    );
  }
}


//juste une class pour override les header d'une sliverList
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
