import 'package:flutter/material.dart';
import 'package:lynight/authentification/test/primary_button.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Connecté\n\nUser id: $userId';
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Erreur connexion\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  Widget _buildUsernameField(){
    return TextFormField(
      key: new Key('email'),
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Saisissez un e-mail valide';
        }
      },
      onSaved: (value) => _email = value,
    );
  }

  Widget _buildPasswordField(){
    return TextFormField(
      key: new Key('password'),
      decoration: InputDecoration(labelText: 'Mot de passe'),
      controller: _passwordTextController,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Au minimum 6 caractères sont requis pour le mot de passe';
        }
      },
      onSaved: (value) => _password = value,
    );
  }

//  List<Widget> usernameAndPassword() {
//    return [
//      padded(child: new TextFormField(
//        key: new Key('email'),
//        decoration: new InputDecoration(labelText: 'Email'),
//        autocorrect: false,
//        validator: (String value) {
//          if (value.isEmpty ||
//              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//                  .hasMatch(value)) {
//            return 'Saisissez un e-mail valide';
//          }
//        },
//        onSaved: (value) => _email = value,
//      )),
//      padded(child: new TextFormField(
//        key: new Key('password'),
//        decoration: new InputDecoration(labelText: 'Mot de passe'),
//        controller: _passwordTextController,
//        obscureText: true,
//        autocorrect: false,
//        validator: (String value) {
//          if (value.isEmpty || value.length < 6) {
//            return 'Au minimum 6 caractères sont requis pour le mot de passe';
//          }
//        },
//        onSaved: (value) => _password = value,
//      )),
//    ];
//  }

  Widget _builConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirmez le mot de passe'),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Le mot de passe ne correspond pas';
        }
      },
    );
  }

  Widget submitWidgets(){
    switch(_formType){
      case FormType.login:
        return Column(
          children: <Widget>[
            PrimaryButton(
                key: new Key('login'),
                text: 'Connexion',
                height: 44.0,
                onPressed: validateAndSubmit
            ),
            FlatButton(
                key: new Key('need-account'),
                child: new Text("Créer un compte"),
                onPressed: moveToRegister
            ),
          ],
        );
      case FormType.register:
        return Column(
          children: <Widget>[
            PrimaryButton(
                key: new Key('register'),
                text: 'Créer',
                height: 44.0,
                onPressed: validateAndSubmit
            ),
            FlatButton(
                key: new Key('need-login'),
                child: new Text("Déjà un compte ? Se connecter"),
                onPressed: moveToLogin
            ),
          ],
        );
    }

    return Container(
      child: Text('Probleme creation du submitWidget'),
    );

  }

//  List<Widget> submitWidgets() {
//    switch (_formType) {
//      case FormType.login:
//        return [
//          new PrimaryButton(
//            key: new Key('login'),
//            text: 'Connexion',
//            height: 44.0,
//            onPressed: validateAndSubmit
//          ),
//          new FlatButton(
//            key: new Key('need-account'),
//            child: new Text("Créer un compte"),
//            onPressed: moveToRegister
//          ),
//        ];
//      case FormType.register:
//        return [
//          new PrimaryButton(
//            key: new Key('register'),
//            text: 'Créer',
//            height: 44.0,
//            onPressed: validateAndSubmit
//          ),
//          new FlatButton(
//            key: new Key('need-login'),
//            child: new Text("Déjà un compte ? Se connecter"),
//            onPressed: moveToLogin
//          ),
//        ];
//    }
//    return null;
//  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(child: new Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildUsernameField(),
                            _buildPasswordField(),
                            _formType == FormType.register
                                ? _builConfirmPasswordTextField()
                                : Container(),
                             SizedBox(
                               height: 10.0,
                             ),
                             submitWidgets(),
                          ],
                        )
                    )
                ),
              ])
            ),
            hintText()
          ]
        )
      ))
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}

