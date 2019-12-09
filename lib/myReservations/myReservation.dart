import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/myReservations/detailReservation.dart';
import 'package:lynight/authentification/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lynight/profilUtilisateur/selectProfilPicture.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListPage extends StatefulWidget {
  ListPage({this.onSignOut, @required this.admin});

//  final BaseAuth auth;
  final VoidCallback onSignOut;
  final bool admin;

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
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String userId = 'userId';
  String userMail = 'userMail';
  List reservation = [];
  CrudMethods crudObj = new CrudMethods();

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

    if(widget.admin){
      crudObj.getDataFromAdminFromDocument().then((value) {
        Map<String, dynamic> dataMap = value.data;
        List reservationList = dataMap['reservation'];
        setState(() {
          reservation = reservationList;
        });
      });
    }else{
      crudObj.getDataFromUserFromDocument().then((value) {
        Map<String, dynamic> dataMap = value.data;
        List reservationList = dataMap['reservation'];
        setState(() {
          reservation = reservationList;
        });
      });
    }
  }

  Widget _makeCard(oneReservationMap) {
    return Card(
      color: Colors.transparent,
      elevation: 15.0,
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
        child: _makeListTile(oneReservationMap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pageConstruct(reservation, context);
  }

  Widget _makeListTile(oneReservationMap) {
    Timestamp reservationDate = oneReservationMap['date'];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 1.0, color: Colors.white),
        )),
        child: Icon(Icons.music_note, color: Colors.white),
      ),
      title: Text(
        oneReservationMap['boiteID'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Icon(Icons.date_range, color: Colors.white, size: 20.0),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                DateFormat('dd/MM/yyyy').format(reservationDate.toDate()),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 25.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(reservation: oneReservationMap)),
        );
      },
    );
  }

  Widget _makeBody(userReservationList) {
    var mutableListOfReservation = new List.from(reservation);
    final SlidableController slidableController = SlidableController();

    if (userReservationList.isEmpty) {
      return Center(
        child: Text(
          'Aucune réservation',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reservation.length,
        itemBuilder: (BuildContext context, int index) {
          var date = DateFormat('dd/MM/yyyy')
              .format(reservation[index]['date'].toDate());
          return Slidable(
            controller: slidableController,
            key: Key(Random().nextInt(1000).toString() +
                reservation[index]['date'].toString()),
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Supprimer',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    reservation =  List.from(reservation)..removeAt(index);
                  });
                  Firestore.instance
                      .collection('user')
                      .document(userId)
                      .updateData({"reservation": reservation});

                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${mutableListOfReservation[index]['boiteID']} du $date Supprimé"),
                      action: SnackBarAction(
                        label: 'annuler',
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            reservation =  List.from(reservation)..insert(
                                index, mutableListOfReservation[index]);
                          });
                          Firestore.instance
                              .collection('user')
                              .document(userId)
                              .updateData(
                              {"reservation": reservation});
                        },
                      )));
                },
              ),
            ],
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                setState(() {
                  reservation =  List.from(reservation)..removeAt(index);
                });
                Firestore.instance
                    .collection('user')
                    .document(userId)
                    .updateData({"reservation": reservation});

                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${mutableListOfReservation[index]['boiteID']} du $date Supprimé"),
                    action: SnackBarAction(
                      label: 'annuler',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          reservation =  List.from(reservation)..insert(
                              index, mutableListOfReservation[index]);
                        });
                        Firestore.instance
                            .collection('user')
                            .document(userId)
                            .updateData(
                            {"reservation": reservation});
                      },
                    )));
              },
            ),
            child: _makeCard(reservation[index]),
          );
        },
      ),
    );
  }

  Widget pageConstruct(userReservationList, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('Mes reservations',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 30),),
      ),
      body: _makeBody(userReservationList),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'Reservations',
        admin: widget.admin,
      ),
    );
  }
}
