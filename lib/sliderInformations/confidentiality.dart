import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
class Confidentiality extends StatefulWidget {

  Confidentiality({this.onSignOut});
  final VoidCallback onSignOut;
  final BaseAuth auth = new Auth();

  void _signOut() async{
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
    return _ConfidentialityState();
  }
}

class _ConfidentialityState extends State<Confidentiality> {
  String userMail = 'userMail';

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text(
          'Confidentialité',
          style: TextStyle(fontSize: 34, color: Theme.of(context).primaryColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text('test'),
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: '/confidentiality',
      ),
    );
  }
}
