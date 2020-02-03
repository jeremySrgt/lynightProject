import 'package:flutter/material.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/authentification/login_page.dart';
import 'package:lynight/principalPage.dart';
import 'package:lynight/services/crud.dart';





enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId;
  bool admin = false;

  CrudMethods crudObj = new CrudMethods();

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user;
        }
      });

      authStatus = user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;

    });
  }

  void loginCallback() {
    widget.auth.currentUser().then((user) {
      setState(() {
        _userId = user.toString();
      });
    });
    //permet de simplifier la gestion de la connaissance du role de l'utilisateur
    //si on trouve des data dans la collection user alors c'est un user
    //sinon il s'agit d'un admin
    //ensuite on root vers la bonne page
    //peut etre un moyen de faire mieux
    //à la création d'un compte on stock dans une collection
    //un document avec l'id du compte et un champ unique contenant le documentreference
    //de l'utilisateur pour ensuite regarde lors de la connexion si le parent du docref est Adminboite ou user
    //et ainsi savoir si l'utilisateur est un admin ou pas


    //permet de ne pas pouvoir se connecter avec un compte pro sur l'app normal
    //on devrati integrer la meme fonction sur l'appli pro pour faire l'inverses
    setState(() {
      crudObj.getDataFromUserFromDocument().then((value){
        print("DONNER DU USER");
        print(value.data);
        if(value.data == null) {
          setState(() {
            admin = true;
            authStatus = AuthStatus.NOT_LOGGED_IN;
          });
        }else{
          setState(() {
            admin = false;
            authStatus = AuthStatus.LOGGED_IN;
          });
        }
      });
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignIn: loginCallback,
          title: "Authentification",
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          print("ROOT VERS PRINCIPALE PAGES");
          return new PrincipalPage(
            userId: _userId,
            auth: widget.auth,
            onSignOut: logoutCallback,
          );
        }
        else
          return buildWaitingScreen();
        break;
      default:
        print("PROBLEME DANS LE ROOT");
        return buildWaitingScreen();
    }
  }
}
