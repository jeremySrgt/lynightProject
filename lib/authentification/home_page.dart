import 'package:flutter/material.dart';
import 'package:lynight/authentification/auth.dart';
class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }

    }

    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(fontSize: 32.0),
        ),
      )
    );
  }
}