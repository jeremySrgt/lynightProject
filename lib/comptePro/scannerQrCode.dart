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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            flex: 4,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("Resultat du scan: $qrText",
                  style: TextStyle(fontSize: 25)
              ),
          ),
            flex: 1,
          )
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
            Container(color: Colors.red,
              child: Text(qrText = arguments.toString()),
            );
          });
      }
    });
  }
}



