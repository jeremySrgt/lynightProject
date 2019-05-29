import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as I;

class SumUp extends StatefulWidget {
  final clubId;

  SumUp({this.clubId});


  @override
  State<StatefulWidget> createState() {
    return _SumUpState();
  }
}

class _SumUpState extends State<SumUp> {
  DateTime selectedDate = DateTime.now();
  GlobalKey globalKey = new GlobalKey();
  CrudMethods crudObj = CrudMethods();
  var formatByte;
  var qrImage;

  Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      I.Image imgFile = I.decodeImage(pngBytes);
//      var test = I.encodePng(imgFile);

      final Directory systemTempDir = Directory.systemTemp;
      final File file = await new File('${systemTempDir.path}/tempimage.png').create();
      file.writeAsBytes(pngBytes);

//      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      setState(() {
        formatByte = pngBytes;
        qrImage = file;
      });
      uploadQrCodeToFirestore();


    } catch (exception) {
      print(exception.toString());
    }
  }

  uploadQrCodeToFirestore() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var random = new Random();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('reservations/${user.uid}/${random.nextInt(9999)}.png');
    final StorageUploadTask task = firebaseStorageRef.putFile(qrImage);
    if (task.isInProgress) {
//      setState(() {
//        _isLoading = true;
//      });
    }
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    addReservationToProfil(url);
    setState(() {
//      _isLoading = false;
    });
//    Navigator.pop(context);
  }

  addReservationToProfil(reservationUrl) {
    Map<String, dynamic> userMap = {
      'reservation': {
        'boiteID': widget.clubId,
        'date': selectedDate,
        'qrcode': reservationUrl
      }
    };
    crudObj.createOrUpdateUserData(userMap);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));
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
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.only(left: 10.0),
                height: 200,
                width: 250,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        clubData['name'],
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
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
                            onPressed: () {
                              _selectDate(context);
                            },
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

  Widget _buttonGenerateQrCode() {
    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Opacity(
            opacity: 0.1,
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
        ]),
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
          ],
        ),
      ),
    );
  }
}
