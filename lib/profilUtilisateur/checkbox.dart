import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';

class MyCheckbox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCheckboxState();
  }
}

class _MyCheckboxState extends State<MyCheckbox> {
  CrudMethods crudObj = new CrudMethods();

  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;


  void initState() {
    super.initState();

    crudObj.getDataFromUserFromDocument().then((value){ // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      Map<String,dynamic> dataMap = value.data; // retourne la Map des donné de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
      Map<dynamic, dynamic> musicMap = dataMap['music'];
      setState(() {
        electro = musicMap['electro'];
        rap = musicMap['rap'];
        rnb = musicMap['rnb'];
        populaire = musicMap['populaire'];
        rock = musicMap['rock'];
        trans = musicMap['trans'];
      });
    });
  }

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            switch (title) {
              case "electro":
                setState(() {
                  electro = value;
                });
                break;
              case "rap":
                setState(() {
                  rap = value;
                });
                break;
              case "rnb":
                setState(() {
                  rnb = value;
                });
                break;
              case "populaire":
                setState(() {
                  populaire = value;
                });
                break;
              case "rock":
                setState(() {
                  rock = value;
                });
                break;
              case "psytrance":
                setState(() {
                  trans = value;
                });
                break;
            }
          },
        )
      ],
    );
  }

  _sendInfoToFireStore() {
    crudObj.createOrUpdateUserData({
      'music': {
        'electro': electro,
        'populaire': populaire,
        'rap': rap,
        'rnb': rnb,
        'rock': rock,
        'trans': trans,
      }
    });
  }

  Widget _checkboxStyle() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('electro', electro),
            SizedBox(
              width: 20,
            ),
            checkbox('populaire', populaire),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('rap', rap),
            SizedBox(
              width: 20,
            ),
            checkbox('rnb', rnb),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('rock', rock),
            SizedBox(
              width: 20,
            ),
            checkbox('psytrance', trans),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                children: <Widget>[
                  _checkboxStyle(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Valider"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                  }
                  _sendInfoToFireStore();
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
