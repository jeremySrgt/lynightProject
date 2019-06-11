import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';


void main() => runApp(MaterialApp(home: ScannerQrCode()));

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
  State<StatefulWidget> createState() => _ScannerQrCode();
}

class _ScannerQrCode extends State<ScannerQrCode> {




  String userMail = 'userMail';
  String userId = 'userId';
  bool checkIfScanOrNot = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Scanner'),
      ),
      body: Stack(
        children: <Widget>[
          Container(// taille appareil photo
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
         verifQrCodeValue(qrText),

        ],
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'ScanQr',
      ),
    );
  }

  bool changeValue(){
    checkIfScanOrNot = true;
    return checkIfScanOrNot;
  }

  Widget buttonToChangeUserScan(){
    return FlatButton(
      color: Colors.red,
      child: Text('next user'),
      onPressed: (){
        setState(() {
          checkIfScanOrNot = true;
        });
      },
    );
  }

  Widget wrongQrCode(qrCodeValue){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red,
        ),
        height: 150,
        width: 250,
        child: Text(qrCodeValue,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        alignment: Alignment(0, 0),
      ),
    );
  }

  Widget goodQrCode(qrCodeValue){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green,
        ),
        height: 150,
        width: 250,
        child: Text(qrCodeValue,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        alignment: Alignment(0, 0),
      ),
    );
  }

  Widget verifQrCodeValue(qrCodeValue){
    if(qrCodeValue != "" && checkIfScanOrNot == false){
      if(RegExp(r"[a-zA-Z]+\s-\s[a-zA-Z]+?\s-\s[0-9]{2}?/[0-9]{2}?/[0-9]{4}?").hasMatch(qrCodeValue) == true ){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            goodQrCode(qrCodeValue),
            buttonToChangeUserScan()
          ],
        );
      }else{
        return Column(
          children: <Widget>[
            wrongQrCode(qrCodeValue),
            buttonToChangeUserScan()
        ],
        );
      }
    }else{
      return Center(

      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          setState(() {
              qrText = arguments.toString();
              checkIfScanOrNot = false;

              //child: Text('hduezh'),
          });
      }
    });
  }
}



