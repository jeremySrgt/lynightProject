import 'package:flutter/material.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'dart:async';

void main() => runApp(SumUp());

class SumUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SumUpState();
  }
}

class _SumUpState extends State<SumUp> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019 ),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String clubId = 'clubId';
  CrudMethods crudObj = CrudMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('club')
//          .document(documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var clubData = snapshot.data;
        return pageConstruct(clubData, context);
      },
    );
  }

  Widget userInfoTopSection(clubData, context) {
    return Container(
        height: 280,
        width: 400,
        child: Image.network(
          'https://edm.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cg_faces:center%2Cq_auto:good%2Cw_768/MTYwMTQwMjIxMzUzNTY4MTE2/cielo.jpg',
        ));
  }

  Widget userBottomSection(clubData, context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.only(left: 10.0),
                height: 300,
                width: 250,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Bridge',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(
                        "Date",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("${selectedDate.toLocal()}"),
                          SizedBox(
                            height: 1.0,
                          ),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select date'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget pageConstruct(clubData, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Réservation'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            userInfoTopSection(clubData, context),
            userBottomSection(clubData, context)
          ],
        ),
      ),
    );
  }
}
