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


  Widget buttonToChangeUserScan(){
    return FlatButton(
      color: Colors.red,
      shape: StadiumBorder(),
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
        child: Text('Success ! \n' + qrCodeValue,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        alignment: Alignment(0, 0),
      ),
    );
  }

  Widget goodQrCode(qrCodeValue){
    List<String> nameOfUser = qrCodeValue.split('-');
    return Center(
      child: Container(
        child: Row(
          children: <Widget>[
            Text('Succes ! '),
            SizedBox(),
            Text('Bienvenue ' + nameOfUser[0]),
            Text('Au club' + nameOfUser[1]),
            Text(' Le : ' + nameOfUser[2] ,style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          ],
        ),
        alignment: Alignment(0, 0),
      ),
    );
  }

  Widget verifQrCodeValue(qrCodeValue){
    Color c = const Color.fromRGBO(0, 0, 0, 0.7);
    if(qrCodeValue != "" && checkIfScanOrNot == false){
      if(RegExp(r"[a-zA-Z]+\s-\s[a-zA-Z]+?\s-\s[0-9]{2}?/[0-9]{2}?/[0-9]{4}?").hasMatch(qrCodeValue) == true ){
        return Container(
            color: c,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              height: 325,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                  Icons.check_circle,
                    color: Colors.green,
                  ) ,
                  goodQrCode(qrCodeValue),
                  SizedBox(height: 35),
                  buttonToChangeUserScan(),
                ],
              ),
            ),
          ),
        );
      }else{
        return Container(
          color: c,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              height: 400,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  wrongQrCode(qrCodeValue),
                  SizedBox(height: 35),
                  buttonToChangeUserScan(),
                ],
              ),
            ),
          ),
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



