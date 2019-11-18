import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
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
  _ScannerQrCode createState() => _ScannerQrCode();
}

class _ScannerQrCode extends State<ScannerQrCode> {
  String userMail = 'userMail';
  String userId = 'userId';
  bool _default = false;

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
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  SizedBox(height: 15),
                                  successInScanning()
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Scannez un QR code",
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
