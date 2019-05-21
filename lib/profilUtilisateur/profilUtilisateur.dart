import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lynight/profilUtilisateur/selectProfilPicture.dart';

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
    final _formKey = GlobalKey<FormState>();
    //DateTime dob = userData['DOB'];
    //String formattedDob = DateFormat('yyyy-MM-dd').format(dob);
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
                  leading: Icon(Icons.music_note),
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
                                            hintText: 'Musique 1'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Musique 2'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Musique 3'),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Musique 1'),
                      Text('Musique 2'),
                      Text('Musique 3'),
                    ],
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(
                    "Email",
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
                                            hintText: 'Adresse mail'),
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
                    userData['mail'],
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
                ListTile(
                  leading: Icon(Icons.phone),
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
                                        decoration: InputDecoration(
                                            hintText: 'Numéro de téléphone'),
                                        keyboardType: TextInputType.number,
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
                  leading: Icon(Icons.date_range),
                  title: Text(
                    "Date de naissance",
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
                                            hintText: 'Date de naissance'),
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
                    'Naissance',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(height: 20),
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

/*
CustomScrollView(slivers: <Widget>[

SliverFillRemaining(
child: Column(
children: <Widget>[
userInfoTopSection(userData),
userBottomSection(userData),
],
),
),
]),
*/
