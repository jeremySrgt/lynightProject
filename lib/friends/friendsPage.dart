import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/widgets/slider.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({this.onSignOut});

//  final BaseAuth auth;
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
    return _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPage> {
  String userId = 'userId';
  String userMail = 'userMail';

  String _friendID;

  CrudMethods crudObj = new CrudMethods();
  static final formKey = new GlobalKey<FormState>();
  bool _isLoading = false;

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

  Widget friendResearch() {
    // la section research est pour le moment directement un ajout avec l'ID
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              key: Key('addViaID'),
              decoration: InputDecoration(
                labelText: 'Ajout par ID (ne pas se tromper)',
                icon: new Icon(
                  FontAwesomeIcons.plusCircle,
                  color: Colors.grey,
                ),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Saisis un ID';
                }
              },
              onSaved: (value) => _friendID = value,
            ),
            PrimaryButton(
              key: new Key('submitclub'),
              text: 'Créer',
              height: 44.0,
              onPressed: () {
                validateAndSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }


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
    }
  }

  Widget friendDemand() {
    return Text('demand section');
  }

  Widget friendList() {
    return Text('friend list section');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Amis'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              friendResearch(),
              // demande à yann pour rechercher par nom - 1ere approche par ID complet
              friendDemand(),
              // streambuilder pour sure
              friendList()
              // streambuilder pour sure
            ],
          ),
        ),
      ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'Amis',
      ),
    );
  }
}
