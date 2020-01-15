import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//FIXME TOUT CE QUI EST RELATIF AU COMPTE PRO A ETE DEPLACE DANS L'APP BLOON PRO

void main() => runApp(MaterialApp(home: ScannerQrCode()));

class ScannerQrCode extends StatefulWidget {
  ScannerQrCode({this.onSignOut});

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
  _ScannerQrCode createState() => _ScannerQrCode();
}

class _ScannerQrCode extends State<ScannerQrCode> {
  String userMail = 'userMail';
  String userId = 'userId';
  bool _default = false;
  List<dynamic> _listePlace;
  String testQrCode = "cSWrs7G9GUXvH9q8jlqH";
  bool _qrEquals = false;
  bool _alreadyScan = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('club')
        .document('-LhKMefcBQ5wcJwluZxY')
        .collection('placesReservees')
        .getDocuments()
        .then((value) {
      setState(() {
        _listePlace = value.documents;
      });
    });
  }
  Map<dynamic, dynamic>_maptest = {};

  _qrCallback(String code) {

    test(code);
    print(_maptest);
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
    print(_maptest);
    /*for (int i = 0; i < _listePlace.length; i++) {
      if (_qrInfo == _listePlace[i].documentID &&
          _listePlace[i]["alreadyScan"] == false) {
        print("------------------");
        print(_listePlace[i]["alreadyScan"]);
        Firestore.instance
            .collection("club")
            .document("-LhKMefcBQ5wcJwluZxY")
            .collection("placesReservees")
            .document(_listePlace[i].documentID)
            .setData({"alreadyScan": true}, merge: true);
        setState(() {
          _qrEquals = true;
          _alreadyScan = false;
          print("Qr equals passe a true");
        });
      }else{
        setState(() {
          _alreadyScan = true;
        });
      }
    }*/
  }

  test(code){
    setState(() {
      _isScanning = true;
    });
    Firestore.instance
        .collection('club')
        .document('-LhKMefcBQ5wcJwluZxY')
        .collection('placesReservees')
        .getDocuments()
        .then((value) {
//      setState(() {
//        _listePlace = value.documents;
//      });
      for (int i = 0; i < value.documents.length; i++) {
        print(value.documents[i].documentID);
        print(value.documents[i]["alreadyScan"]);
        if (code == value.documents[i].documentID && value.documents[i]["alreadyScan"] == false) {
          print("DANS LE 1ER IF");
          Firestore.instance
              .collection("club")
              .document("-LhKMefcBQ5wcJwluZxY")
              .collection("placesReservees")
              .document(value.documents[i].documentID)
              .setData({"alreadyScan": true}, merge: true);
          setState(() {
            _maptest = {"code": code, "alreadyScan": false};
          });
          break;

        }else if(code == value.documents[i].documentID && value.documents[i]["alreadyScan"] == true){
          print("DANS LE 2ER IF");
          setState(() {
            _maptest = {"code": code, "alreadyScan": true};
          });

          break;
        }else{
          print("DANS LE 13ER IF");
          setState(() {
            _maptest = {};
          });
        }
      }
      setState(() {
        _isScanning = false;
      });
    });


  }

  String _qrInfo = 'Scan un code';
  bool _camState = false;

  _scanCode() {
    setState(() {
      _camState = true;
      _default = true;
    });
  }

  Widget successInScanning() {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Succes ! ',
              style: TextStyle(fontSize: 20, color: Colors.green)),
          SizedBox(height: 15),
          Text('Bienvenue ', style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text(_qrInfo, style: TextStyle(fontSize: 25))
        ],
      ),
    );
  }

  Widget compareQrCode() {
    return Center(
        child: _qrEquals
            ? Container(
                child: Column(
                  children: <Widget>[
                    Text("C'est bien le même QR Code" + "\n" + _qrInfo + "\n")
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    Text("Pas les mêmes " +
                        "\n" +
                        _qrInfo +
                        "\n" +
                        _listePlace[2].documentID)
                  ],
                ),
              ));
  }

  Widget checkPlace() {
    if(_isScanning){
      return Text("...");
    }
    print(_maptest);
    if(_maptest["alreadyScan"] == true ){
      return Text("C'est PAS  bon DEJA SCAN! ");
    }else if(_maptest["alreadyScan"] == false){
      return Text("C'est bon bienvenu!");

    }else{
      return Text("Pas de placeeeeeeeeeeee");
    }
  }

  Widget errorInScan() {
    return Center(
      child: QrCamera(
        onError: (context, error) => Text(
          error.toString(),
          style: TextStyle(color: Colors.red),
        ),
        qrCodeCallback: (code) {
          _qrCallback(code);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner Qr code'),
      ),
      body: _camState
          ? Center(
              child: SizedBox(
                width: 512,
                height: 1024,
                child: QrCamera(
                  onError: (context, error) => Text(
                    error.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  qrCodeCallback: (code) {
                    _qrCallback(code);
                  },
                ),
              ),
            )
          : Center(
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _default
                        ? Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[checkPlace()],
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  _listePlace == null
                                      ? Text(
                                          "Y a rien dans la liste",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      : Text(
                                          _listePlace[1]['price'].toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                alignment: Alignment(0, 0),
              ),
            ),
      floatingActionButton: Visibility(
        visible: !_camState,
        child: FloatingActionButton(
          onPressed: _scanCode,
          tooltip: 'Scan',
          child: Icon(Icons.scanner),
        ),
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'ScanQr',
      ),
    );
  }
}
