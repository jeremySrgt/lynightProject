import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/crud.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as I;

class SumUp extends StatefulWidget {
  final String clubName;
  final String clubId;

  SumUp({@required this.clubName, @required this.clubId});

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
  List reservation;
  var formatByte;
  var qrImage;
  bool generationClicked = false;
  bool renderReady = false;
  bool _isLoading = false;
  String userName = '';

  List<dynamic> _listPlacesDispo;
  String _selectedPlace;
  Map<dynamic, dynamic>_mapSelectedPlace;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.deepPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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
        userName = dataMap['name'];
      });
    });

    Firestore.instance
        .collection('club')
        .document('-LhKMefcBQ5wcJwluZxY')
        .collection('placesDispo')
        .getDocuments()
        .then((value) {
      setState(() {
        _listPlacesDispo = value.documents;
        _selectedPlace = value.documents[0].documentID.toString();
        _mapSelectedPlace = value.documents[0].data;
      });
    });
  }

  Future<void> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      I.Image imgFile = I.decodeImage(pngBytes);
//      var test = I.encodePng(imgFile);

      final Directory systemTempDir =
          await getTemporaryDirectory(); //permet d'avoir n'import quel chemin de de TempDirectory peu importe le tel
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
      changePlaceState();
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
      setState(() {
        _isLoading = true;
      });
    }
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    addReservationToProfil(url);
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
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
  }

  changePlaceState() {

    //delete the place from placesDispo
    Firestore.instance
        .collection('club')
        .document(widget.clubId)
        .collection('placesDispo')
        .document(_selectedPlace)
        .delete()
        .catchError((e) {
      print(e);
    });

    //add the place to placesReservees
    Firestore.instance.collection('club').document(widget.clubId).collection('placesReservees').document(_selectedPlace).setData(_mapSelectedPlace);

  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return pageConstruct(context);
  }

  Widget userBottomSection(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: FractionalOffset.center,
//                  height: 400, //ne pas definir de height permet au container de prendre seulement la place qu'il a besoin et pas plus
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.clubName,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              leading: Icon(
                                Icons.access_time,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ),
                              title: Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18.0),
                              ),
                              subtitle: Container(
                                alignment: FractionalOffset.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                      child: Container(
                                        width: width / 2.5,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color.fromRGBO(
                                                      212, 63, 141, 1),
                                                  Color.fromRGBO(2, 80, 197, 1)
                                                ]),
                                            //color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Center(
                                            child: Text(
                                          "Choisir une date",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buttonGenerateQrCode(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buttonGenerateQrCode() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: () {
        setState(() {
          generationClicked = true;
        });
        _getWidgetImage();
      },
      child: Container(
        width: width / 2.5,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(212, 63, 141, 1),
                  Color.fromRGBO(2, 80, 197, 1)
                ]),
            //color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Center(
            child: Text(
          "C\'est ok !",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  _showQrGenerating() {
    return Opacity(
      opacity: 0.1, //mettre à 0.1 pour le rendre invisible
      child: Column(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: QrImage(
              data: _selectedPlace,
              size: 200.0,
              version: 8,
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _showLoadingQr(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Opacity(
      opacity: 0.7,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.only(
              top: height / 5,
              bottom: height / 5,
              left: width / 7,
              right: width / 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearPercentIndicator(
                width: 300.0,
                lineHeight: 15.0,
                animation: true,
                animationDuration: 1050,
                percent: 1.0,
                progressColor: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50, top: 7),
                child: Text(
                  'Generation QR Code',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageConstruct(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Réservation',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                userBottomSection(context),
                SizedBox(
                  height: 12,
                ),
                Stack(
                  children: <Widget>[
                    _showQrGenerating(),
                    Container(
                      height: 200,
                      width: 200,
                      color: Colors
                          .white, // mettre Colors.red permet de voir ou est placé le qr code invisible, pratique pour debug en fonction des differentes taille de portable
                      //mettre Colors.white pour rendre le qr invisible
                    ),
                  ],
                ),
              ],
            ),
          ),
          generationClicked == true ? _showLoadingQr(context) : Container(),
        ],
      ),
    );
  }
}
