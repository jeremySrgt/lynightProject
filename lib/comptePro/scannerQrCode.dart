import 'package:flutter/material.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/widgets/slider.dart';

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
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ScannerQrCodeState();
  }
}

class _ScannerQrCodeState extends State<ScannerQrCode> {

  String userMail = 'userMail';
  String userId = 'userId';


  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Scanner'),
      ),
      body: Center(
        child: Text('hello scanner'),
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'ScanQr',
      ),
    );
  }
}
