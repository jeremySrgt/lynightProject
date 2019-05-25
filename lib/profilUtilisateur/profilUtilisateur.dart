import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lynight/profilUtilisateur/selectProfilPicture.dart';
import 'package:lynight/profilUtilisateur/checkbox.dart';

class UserProfil extends StatefulWidget {
  UserProfil({this.onSignOut});

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
    return _UserProfilState();
  }
}

class _UserProfilState extends State<UserProfil> {
  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();
  String userMail = 'userMail';
  
  String _phoneNumber;
  String _name;
  String _surname;

  bool _notificationValue = true;


  void _onChangedNotification(bool value){
    setState(() {
      _notificationValue = value;
    });
    crudObj.createOrUpdateUserData({'notification':_notificationValue});
  }


  void initState() {
    super.initState();
    //grace a ca principalPage s'occupe de recuperer les informations de l'utilisateur actif - peut etre pas le meilleur choix mais ca fonctionne
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
    crudObj.getDataFromUserFromDocument().then((value){ // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      Map<String,dynamic> dataMap = value.data; // retourne la Map des donné de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
      setState(() {
      _notificationValue = dataMap['notification'];
      });
    });
  }

  void _openModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF737373)),
              color: Color(0xFF737373),
            ),
            child: Container(
              child: SelectProfilPicture(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
            ),
          );
        });
  }


  String validateEmail(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Saisissez un e-mail valide';
    }
    else
      return null;
  }

  String validatePhone(String value) {
    if (value.length != 10)
      return 'Veuillez entrer un numéro valide';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('user').document(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userData = snapshot.data;
        return pageConstruct(userData, context);
      },
    );
  }

  Widget userInfoTopSection(userData) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.4,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32), bottomLeft: Radius.circular(32)),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Centrer les icones et l'image sur la page
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
//                      Navigator.push(context, MaterialPageRoute(
//                          builder: (context) => SelectProfilPicture()));
                      _openModalBottomSheet(context);
                    },
                    child: CircleAvatar(
                      // photo de profil
                      backgroundImage: NetworkImage(userData['picture']),
                      minRadius: 30,
                      maxRadius: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userBottomSection(userData) {

    Map<dynamic,dynamic> musicMap = userData['music'];

    final _formKey = GlobalKey<FormState>();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                ),
                ListTile(
                  leading: Icon(Icons.person,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Prénom",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Prénom'),
                                        onSaved: (value) => _name = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Valider"),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            crudObj.createOrUpdateUserData({'name':_name});
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  subtitle: Text(
                    userData['name'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.supervisor_account,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Nom",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Nom'),
                                        onSaved: (value) => _surname = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Valider"),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            crudObj.createOrUpdateUserData({'surname':_surname});
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  subtitle: Text(
                    userData['surname'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.mail,color: Theme.of(context).accentColor,),
                  title: Text(
                    'Mail',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    userMail,
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.phone,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Numéro",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        validator: validatePhone,
                                        decoration: InputDecoration(
                                            hintText: 'Numéro de téléphone'),
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) => _phoneNumber = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Valider"),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            crudObj.createOrUpdateUserData({'phone':_phoneNumber});
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  subtitle: Text(
                    userData['phone'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.music_note,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Style de musique",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyCheckbox();
                          });
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      musicMap['electro'] == true ? Text('Electro') : Container(),
                      musicMap['populaire'] == true ? Text('Populaire') : Container(),
                      musicMap['rap'] == true ? Text('Rap') : Container(),
                      musicMap['rnb'] == true ? Text('RnB') : Container(),
                      musicMap['rock'] == true ? Text('Rock') : Container(),
                      musicMap['trans'] == true ? Text('Psytrance') : Container(),
                    ],
                  ),
                ),
                Container(height: 20),

                ListTile(
                  leading: Icon(Icons.date_range,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Date de naissance",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(userData['DOB'].toDate()),
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.notifications,color: Theme.of(context).accentColor,),
                  title: Text(
                    "Notification",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18.0),
                  ),
                  trailing: Switch(value: _notificationValue, onChanged: _onChangedNotification),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget pageConstruct(userData, context) {
    return Scaffold(
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'Profil',
      ),
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: userData['name'] == ""
                  ? Text(userMail)
                  : Text(userData['name'] + ' ' + userData['surname']),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: userInfoTopSection(userData),
                ),
                Container(
                  child: userBottomSection(userData),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
