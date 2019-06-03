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
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:image/image.dart' as I;

class SumUp extends StatefulWidget {
  final String clubName;

  SumUp({this.clubName});

  @override
  State<StatefulWidget> createState() {
    return _SumUpState();
  }
}

class _SumUpState extends State<SumUp> {
  DateTime selectedDate = DateTime.now();
  GlobalKey globalKey = new GlobalKey();
  CrudMethods crudObj = CrudMethods();
  List reservation;
  var formatByte;
  var qrImage;
  bool generationClicked = false;
  bool renderReady = false;

  void initState() {
    super.initState();
    //permet de choper la liste de toute les reservations
    crudObj.getDataFromUserFromDocument().then((value) {
      // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      Map<String, dynamic> dataMap = value
          .data; // retourne la Map des donné de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
      List reservationList = dataMap['reservation'];
//      print(reservationList);
      setState(() {
        reservation = reservationList;
      });
    });
  }

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
      final File file =
          await new File('${systemTempDir.path}/tempimage.png').create();
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

  addReservationToProfil(reservationUrl) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Map<String, dynamic> reservationInfo = {
      'boiteID': widget.clubName,
      'date': selectedDate,
      'qrcode': reservationUrl
    };

    var mutableListOfReservation = new List.from(reservation);

    mutableListOfReservation.add(reservationInfo);

    Firestore.instance
        .collection('user')
        .document(user.uid)
        .updateData({"reservation": mutableListOfReservation});
//    crudObj.createOrUpdateUserData(userMap);
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
    return pageConstruct(widget.clubName, context);
  }

  Widget userBottomSection(context) {
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
                        widget.clubName,
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
    return RaisedButton(
      onPressed: () {
        setState(() {
          generationClicked = true;
        });
        _getWidgetImage();
      },
      child: Text('generer QR code'),
    );
  }

  _showQrGenerating() {
    return Opacity(
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
    );
  }

  Widget pageConstruct(clubData, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Réservation'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                userBottomSection(context),
                _buttonGenerateQrCode(),
                Stack(
                  children: <Widget>[
                    _showQrGenerating(),
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.7,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 60),//pas responsive du tout
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LinearPercentIndicator(
                      width: 300.0,
                      lineHeight: 15.0,
                      percent: 0.4,
                      progressColor: Colors.red,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text('Generation QR Code'),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
