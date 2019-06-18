import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventInvitation extends StatefulWidget {
  EventInvitation({this.onSignOut});

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
    return _EventInvitationState();
  }
}

class _EventInvitationState extends State<EventInvitation> {
  String currentUserId = 'userId';
  String currentUserMail = 'userMail';

  RefreshController _refreshController;
  CrudMethods crudObj = new CrudMethods();

  List<dynamic> invitationList = [];
  String userName = '';

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

  Widget _invitation() {
    if (invitationList.isEmpty) {
      return Center(
        child: Text('Aucune invitation, désolé t\'as pas d\'amis'),
      );
    }

    return ListView.builder(
      itemCount: invitationList.length,
      itemBuilder: (context, i) {
        Timestamp invitationDate = invitationList[i]['date'];
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Card(
            elevation: 2.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.glassCheers),
                  title: Text(invitationList[i]['who'] + ' t\'invite à sortir '),
                  subtitle: Text(invitationList[i]['boite'] + ' le ' + DateFormat('dd/MM/yyyy')
                      .format(invitationDate.toDate())),
                ),
                ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('NOPE'),
                        onPressed: () {
                          //TODO supprimer l'invitation
                        },
                      ),
                      FlatButton(
                        child: const Text('LET\'S GO'),
                        onPressed: () {
                          //TODO ajouter à la liste des reservations une resa pour le club et la date décrite dans l'invitation
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLoading() {
    return crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        invitationList = dataMap['invitation'];
        userName = dataMap['name'];
      });

      _refreshController.loadComplete();
    });
  }

  void _refresh() {
    return crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        invitationList = dataMap['invitation'];
        userName = dataMap['name'];
      });

      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        // pour éviter l'ombre qui fait moche avec l'animation du refresh
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Invitation',
          style: TextStyle(color: Colors.white, fontSize: 30),
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
        child: _invitation(),
      ),
      drawer: CustomSlider(
        userMail: currentUserMail,
        signOut: widget._signOut,
        activePage: 'Invitation',
      ),
    );
  }
}
