import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:lynight/principalPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return 'L\'Email n\'est pas renseigné';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),

            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return 'Saisissez un mot de passe';
                }
                if(input.length < 6){
                  return 'Le mot de passe doit faire au moins 6 caractères';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(
                labelText: 'Mot De Passe',
              ),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async{
    final formState = _formKey.currentState;

    if(formState.validate()){
      formState.save();

      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrincipalPage(user: user)));
      }
      catch(e){
        print('ERROR ' + e.message);
      }

    }
  }

}
