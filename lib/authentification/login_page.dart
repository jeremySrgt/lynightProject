import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/services/userData.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  static final formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  CrudMethods crudObj = new CrudMethods();

  String _email;
  String _password;
  DateTime dob;
  String _name;
  FormType _formType = FormType.login;
  String _authHint = '';
  bool _isLoading = false;
  bool userSex = true;

  int _radioValue = 0;
  Color dobColor = Colors.grey[600];

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
      setState(() {
        _isLoading = true;
      });
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _isLoading = false;
        });
        widget.onSignIn();
        if (_formType == FormType.register) {
          UserData userData = new UserData(
              name: _name,
              surname: "",
              dob: dob,
              favoris: [],
              mail: _email,
              music: {
                'electro': true,
                'populaire': true,
                'rap': true,
                'rnb': true,
                'rock': true,
                'trans': true,
              },
              notification: true,
              phone: "",
              picture:
                  "https://firebasestorage.googleapis.com/v0/b/lynight-53310.appspot.com/o/profilePics%2Fbloon_pics.jpg?alt=media&token=ab6c1537-9b1c-4cb4-b9d6-2e5fa9c7cb46",
              reservation: [],
              sex: userSex,
              pro: false,
              friendRequest: [],
              friendList: [],
              invitation: []);
          crudObj.createOrUpdateUserData(userData.getDataMap());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
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

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('email'),
        decoration: InputDecoration(
          labelText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Saisissez un e-mail valide';
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('namefield'),
        decoration: InputDecoration(
          labelText: 'Prénom',
          icon: new Icon(
            Icons.perm_identity,
            color: Colors.grey,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un prénom';
          }
        },
        onSaved: (value) => _name = value,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('password'),
        decoration: InputDecoration(
            labelText: 'Mot de passe',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: _passwordTextController,
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return '6 caractères minimum sont requis';
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _builConfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Confirmez le mot de passe',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value) {
            return 'Le mot de passe ne correspond pas';
          }
        },
      ),
    );
  }

  Widget _showDatePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.date_range,
            color: Colors.grey,
          ),
          FlatButton(
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(1968, 1, 1),
                maxTime: DateTime(2030, 6, 7),
                onConfirm: (date) {
                  setState(() {
                    dob = date;
                    dobColor = Colors.grey[600];
                  });
                },
                currentTime: DateTime.now(),
                locale: LocaleType.fr,
              );
            },
            child: Text(
              dob == null
                  ? 'Date de naissance'
                  : DateFormat('dd/MM/yyyy').format(dob),
              style: TextStyle(color: dobColor, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          userSex = true;
          break;
        case 1:
          userSex = false;
          break;
      }
    });
  }

  Widget _showGenderSelect() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.venusMars,
            color: Colors.grey,
          ),
          Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text(
            'Homme',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text('Femme', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
              key: new Key('login'),
              text: 'Connexion',
              height: 44.0,
              onPressed: validateAndSubmit,
            ),
            FlatButton(
                key: new Key('need-account'),
                child: Text("Créer un compte"),
                onPressed: moveToRegister),
          ],
        );
      default:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
                key: new Key('register'),
                text: 'Créer',
                height: 44.0,
                onPressed: () {
                  if (dob == null) {
                    validateAndSave();
                    setState(() {
                      dobColor = Colors.red[700];
                    });
                  } else {
                    validateAndSubmit();
                  }
                }),
            FlatButton(
                key: new Key('need-login'),
                child: Text("Déjà un compte ? Se connecter"),
                onPressed: moveToLogin),
          ],
        );
    }
  }

  Widget _showCircularProgress() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: new Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  Widget _buildForm() {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showLogo(),
            _buildUsernameField(),
            _formType == FormType.register ? _buildNameField() : Container(),
            _buildPasswordField(),
            _formType == FormType.register
                ? _builConfirmPasswordTextField()
                : Container(),
            _formType == FormType.register ? _showDatePicker() : Container(),
            SizedBox(
              height: 10.0,
            ),
            _formType == FormType.register ? _showGenderSelect() : Container(),
            _isLoading == false ? submitWidgets() : _showCircularProgress()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ]),
            hintText(),
          ]),
        ),
      ),
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  Widget _showLogo() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          height: 200,
          width: 500,
          child: FlareActor(
            "assets/splash_screen_bloon.flr",
            alignment: Alignment.center,
            fit: BoxFit.cover,
            animation: "intro",
            shouldClip: true,
          ),
        ));
  }
}
