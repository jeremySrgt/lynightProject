import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'dart:async';
import 'package:lynight/qrCode/qrCodeGeneration.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SumUp extends StatefulWidget {
  final clubId;

  SumUp({this.clubId});

  @override
  State<StatefulWidget> createState() {
    return _SumUpState();
  }
}

class _SumUpState extends State<SumUp> {
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  DateTime selectedDate = DateTime.now();
  GlobalKey globalKey = new GlobalKey();
  CrudMethods crudObj = CrudMethods();
  var formatByte;

  Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(bs64);
      print(pngBytes);
      setState(() {
        formatByte = pngBytes;
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('club')
          .document(widget.clubId)
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

  Widget userBottomSection(clubData, context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: FractionalOffset.center,
//                margin: EdgeInsets.only(left: 10.0),
                height: 300,
                width: 300,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        clubData['name'],
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 5.0),
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text(
                              "Date",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18.0),
                            ),
                            subtitle: Container(
                              alignment: FractionalOffset.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                      'Date choisie: ' +
                                          dateFormat.format(selectedDate),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                  RaisedButton(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Text('Choisir une date',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.black87,
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text(
                              "Informations utiles",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18.0),
                            ),
                            subtitle: Container(
                                alignment: FractionalOffset.centerLeft,
                                child: Text(
                                  clubData['adress'] +
                                      '\n' +
                                      '\n' +
                                      clubData['phone'],
                                  style: TextStyle(fontSize: 15.0),
                                )),
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

  Widget _buttonGenerateQrCode() {
    return Column(
      children: <Widget>[
        Opacity(
          opacity: 1.0,
          child: Column(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: "jeremy",
                  size: 200.0,
                  version: 8,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        RaisedButton(
          onPressed: () {
            _getWidgetImage();
          },
          child: Text('generer QR code'),
        )
      ],
    );
  }

  Widget pageConstruct(clubData, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Réservation'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            userBottomSection(clubData, context),
            _buttonGenerateQrCode(),
            formatByte == null ? Container() : Image.memory(formatByte),
          ],
        ),
      ),
    );
  }
}
