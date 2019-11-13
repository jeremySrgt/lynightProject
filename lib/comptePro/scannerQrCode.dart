import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: ScannerQrCode(),
    );
  }
}

class ScannerQrCode extends StatefulWidget {


  ScannerQrCode({this.onSignOut});

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
  _ScannerQrCode createState() => _ScannerQrCode();
}

class _ScannerQrCode extends State<ScannerQrCode> {

  String userMail = 'userMail';
  String userId = 'userId';



  _qrCallback(String code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
  }

  String _qrInfo = 'Scan un code batard';
  bool _camState = false;
  _scanCode() {
    setState(() {
      _camState = true;
    });
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
        child: Text(_qrInfo),
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




//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'package:lynight/widgets/slider.dart';
//import 'package:lynight/authentification/auth.dart';
//
//
////void main() => runApp(MaterialApp(home: ScannerQrCode()));
//
//class ScannerQrCode extends StatefulWidget {
//
//
//  ScannerQrCode({this.onSignOut});
//
//  final VoidCallback onSignOut;
//
//  BaseAuth auth = new Auth();
//
//  void _signOut() async {
//    try {
//      await auth.signOut();
//      onSignOut();
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  @override
//  State<StatefulWidget> createState() => _ScannerQrCode();
//}
//
//class _ScannerQrCode extends State<ScannerQrCode> {
//
//  String userMail = 'userMail';
//  String userId = 'userId';
//  bool checkIfScanOrNot = false;
//
//  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//  var qrText = "";
//  QRViewController controller;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        backgroundColor: Theme.of(context).primaryColor,
//        title: Text('Scanner'),
//      ),
//      body: Stack(
//        children: <Widget>[
//          Container(// taille appareil photo
//            child: QRView(
//              key: qrKey,
//              onQRViewCreated: _onQRViewCreated,
//            ),
//          ),
//         verifQrCodeValue(qrText),
//
//        ],
//      ),
//      drawer: CustomSlider(
//        userMail: userMail,
//        signOut: widget._signOut,
//        activePage: 'ScanQr',
//      ),
//    );
//  }
//
//
//  Widget buttonToChangeUserScanWrong(){
//    return FlatButton(
//      color: Color(0xFFffb2b2),
//      shape: StadiumBorder(),
//      child: Text(
//          'Réessayer',
//          style: TextStyle(
//              fontSize: 20,
//          color: Color(0xFFef0000)
//          )
//      ),
//      onPressed: (){
//        setState(() {
//          checkIfScanOrNot = true;
//        });
//      },
//    );
//  }
//
//  Widget buttonToChangeUserScanGood(){
//    final greenForced = const Color.fromRGBO(66, 163, 65, 1);
//    final greenLight = const Color.fromRGBO(184, 226, 163, 1);
//    return RaisedButton(
//      color: greenLight,
//      elevation: 5,
//      shape: StadiumBorder(),
//      child: Text(
//          'Ok',
//          style: TextStyle(
//              fontSize: 20,
//              color: greenForced,
//              fontWeight: FontWeight.bold
//          )
//      ),
//      onPressed: (){
//        setState(() {
//          checkIfScanOrNot = true;
//        });
//      },
//    );
//  }
//
//  Widget wrongQrCode(qrCodeValue){
//    return Center(
//      child: Container(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text('Qr code invalide ! ', style: TextStyle(fontSize: 20, color: Colors.red)),
//            SizedBox(height: 15),
//            Text('Erreur le qr code ne correspond pas : ', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
//            SizedBox(height: 15),
//            Text(qrCodeValue),
//          ],
//        ),
//        alignment: Alignment(0, 0),
//      ),
//    );
//  }
//
//  Widget goodQrCode(qrCodeValue){
//    List<String> nameOfUser = qrCodeValue.split('-');
//    return Center(
//      child: Container(
//        child: Column(
//          children: <Widget>[
//            Text('Succes ! ', style: TextStyle(fontSize: 20, color: Colors.green)),
//            SizedBox(height: 15),
//            Text('Bienvenue ' + nameOfUser[0], style: TextStyle(fontSize: 20)),
//            SizedBox(height: 15),
//            Text('Au club ' + nameOfUser[1], style: TextStyle(fontSize: 20)),
//            SizedBox(height: 15),
//            Text('Le : ' + nameOfUser[2], style: TextStyle(fontSize: 20)),
//          ],
//        ),
//        alignment: Alignment(0, 0),
//      ),
//    );
//  }
//
//  Widget verifQrCodeValue(qrCodeValue){
//    Color c = const Color.fromRGBO(0, 0, 0, 0.7);
//    if(qrCodeValue != "" && checkIfScanOrNot == false){
//      if(RegExp(r"[a-zA-Z]+\s-\s[a-zA-Z]+?\s-\s[0-9]{2}?/[0-9]{2}?/[0-9]{4}?").hasMatch(qrCodeValue) == true ){
//        return Container(
//            color: c,
//          child: Center(
//            child: Container(
//              decoration: BoxDecoration(
//                border: Border.all(color: Colors.black),
//                borderRadius: BorderRadius.circular(25.0),
//                color: Colors.white,
//              ),
//              height: 325,
//              width: 300,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                  Icons.check_circle,
//                    color: Colors.green,
//                    size: 30,
//                  ) ,
//                  SizedBox(height: 10),
//                  goodQrCode(qrCodeValue),
//                  SizedBox(height: 35),
//                  buttonToChangeUserScanGood(),
//                ],
//              ),
//            ),
//          ),
//        );
//      }else{
//        return Container(
//          color: c,
//          child: Center(
//            child: Container(
//              decoration: BoxDecoration(
//                border: Border.all(color: Colors.black),
//                borderRadius: BorderRadius.circular(25.0),
//                color: Colors.white,
//              ),
//              height: 325,
//              width: 300,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                Icons.cancel,
//                color: Colors.red,
//                    size: 30,
//              ),
//                  SizedBox(height: 10),
//                  wrongQrCode(qrCodeValue),
//                  SizedBox(height: 35),
//                  buttonToChangeUserScanWrong(),
//                ],
//              ),
//            ),
//          ),
//        );
//      }
//    }else{
//      return Center(
//
//      );
//    }
//  }
//
//  void _onQRViewCreated(QRViewController controller) {
//    this.controller = controller;
//    controller.scannedDataStream.listen((scanData) {
//      setState(() {
//        qrText = scanData;
//      });
//    });
//  }
//}
//
//
//
