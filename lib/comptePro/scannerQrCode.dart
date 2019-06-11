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
          qrText == "" ? Container(): Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green,
              ),
              height: 150,
              width: 250,
              child: Text(qrText,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              alignment: Alignment(0, 0),
            )
          ),
        ],
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'ScanQr',
      ),
    );
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

              //child: Text('hduezh'),
          });
      }
    });
  }
}



