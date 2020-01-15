import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/comptePro/addClub.dart';
import 'package:lynight/profilUtilisateur/profilUtilisateur.dart';
import 'package:lynight/myReservations/myReservation.dart';
import 'package:lynight/friends/friendsPage.dart';
import 'package:lynight/friends/eventInvitation.dart';
import 'package:lynight/test/testAdminBoite.dart';
import 'package:lynight/main.dart';
import 'package:provider/provider.dart';
import 'package:lynight/favorites/favoritesNightClub.dart';

class CustomSlider extends StatefulWidget {

  CustomSlider({@required this.userMail, @required this.signOut,  @required this.activePage});
  final String userMail;
  final Function signOut;
  final String activePage;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomSliderState();
  }
}

class _CustomSliderState extends State<CustomSlider> {
  CrudMethods crudObj = new CrudMethods();
  String name = 'UserName';
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/lynight-53310.appspot.com/o/profilePics%2Fbloon_pics.jpg?alt=media&token=ab6c1537-9b1c-4cb4-b9d6-2e5fa9c7cb46';
  int numberOfFriendRequest = 0;
  int numberOfInvitation = 0;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.deepPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  void initState() {
    super.initState();
      crudObj.getDataFromUserFromDocument().then((value) {
        // correspond à await Firestore.instance.collection('user').document(user.uid).get();
        Map<String, dynamic> dataMap = value
            .data; // retourne la Map des donné de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
        setState(() {
          name = dataMap['name'];
          profilePicture = dataMap['picture'];
          numberOfFriendRequest = dataMap['friendRequest'].length;
          numberOfInvitation = dataMap['invitation'].length;
        });
      });
  }

  Widget header(context) {
    //peut etre faire du drawer hearder un streamBuilder pour eviter les chargement de la photo de profil a chaque ouverture du drawer
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              // photo de profil
              backgroundImage: NetworkImage(profilePicture),
              minRadius: 25,
              maxRadius: 25,
            ),
            title: name == ''
                ? Text('Pas de prénom')
                : Text(
                    name,
                    style: TextStyle(
                        fontSize: 20.0,
                        foreground: Paint()..shader = linearGradient),
                  ),
            subtitle: Text(
              widget.userMail,
              style: TextStyle(fontSize: 11.0),
            ),
          ),
          ButtonTheme(
            minWidth: 160.0,
            child: RaisedButton.icon(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              label: Text(
                'Profil',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              icon: Icon(Icons.account_circle),
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              onPressed: (){
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(10);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => UserProfil(onSignOut: widget.signOut)));
              },
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColor))),
    );
  }

  Widget scanQrPro() {
    return Container(
      decoration: widget.activePage == 'ScanQr'
          ? BoxDecoration(
              color: Color(0xFFebdffc),
              borderRadius: BorderRadius.circular(15.0))
          : BoxDecoration(),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.qrcode,
          color: widget.activePage == 'ScanQr'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        title: Text(
          'Scanner QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.activePage == 'ScanQr'
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/scannerQrCode');
        },
      ),
    );
  }

  Widget addClubPro() {
    return Container(
      decoration: widget.activePage == 'AddClub'
          ? BoxDecoration(
              color: Color(0xFFebdffc),
              borderRadius: BorderRadius.circular(15.0))
          : BoxDecoration(),
      child: ListTile(
        leading: Icon(
          Icons.add_circle,
          color: widget.activePage == 'AddClub'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        title: Text(
          'Ajouter un club',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.activePage == 'AddClub'
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => AddClub()));
        },
      ),
    );
  }


  Widget _showNotifFriendRequest(){
    if(numberOfFriendRequest == 0){
      return Text('');
    }
    if(numberOfFriendRequest == 1){
      return Text(
        numberOfFriendRequest.toString() + ' demande',
        style: TextStyle(color: Color(0xFFce3737)),
      );
    }

    return Text(
      numberOfFriendRequest.toString() + ' demandes',
      style: TextStyle(color: Color(0xFFce3737)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentDrawer = Provider.of<DrawerStateInfo>(context).getCurrentDrawer;
    return Drawer(
      child: ListView(
        children: <Widget>[
          header(context),
          Container(
            decoration: currentDrawer == 0
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: currentDrawer == 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Accueil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Accueil') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          Container(
            decoration: currentDrawer == 1
                ? BoxDecoration(
                color: Color(0xFFebdffc),
                borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.favorite,
                color: currentDrawer == 1
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Favoris',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Favoris') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => FavoritesNightClub()));
              },
            ),
          ),
          Container(
            decoration: currentDrawer == 2
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.book,
                color: currentDrawer == 2
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Réservations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 2
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Reservations') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(2);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => ListPage()));
              },
            ),
          ),
          Container(
            decoration: currentDrawer == 3
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.mapMarked,
                color: currentDrawer == 3
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Carte',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 3
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Maps') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(3);
                Navigator.pushReplacementNamed(context, '/maps');
              },
            ),
          ),
          Container(
            decoration: currentDrawer == 4
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.userFriends,
                color: currentDrawer == 4
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Amis',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 4
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              trailing: _showNotifFriendRequest(),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Amis') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(4);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => FriendsPage()));
              },
            ),
          ),
          Container(
            decoration: currentDrawer == 5
                ? BoxDecoration(
                color: Color(0xFFebdffc),
                borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.compactDisc,
                color: currentDrawer == 5
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Évènements',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 5
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              trailing: numberOfInvitation != 0
                  ? Text(
                numberOfInvitation.toString() + '',
                style: TextStyle(color: Color(0xFFce3737)),
              )
                  : Text(''),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'Invitation') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(5);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => EventInvitation()));
              },
            ),
          ),


          Container(
            decoration: currentDrawer == 6
                ? BoxDecoration(
                color: Color(0xFFebdffc),
                borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.tenge,
                color: currentDrawer == 6
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'TEST',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 6
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'test') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(6);
                Navigator.pushReplacement(context ,MaterialPageRoute(builder: (BuildContext context) => TestAdminBoite()));
              },
            ),
          ),


          Divider(),
          Container(
            decoration: currentDrawer == 7
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.infoCircle,
                color: currentDrawer == 7
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'À propos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDrawer == 7
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(widget.activePage == 'about') return;
                Provider.of<DrawerStateInfo>(context).setCurrentDrawer(7);
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
          ),
        ],
      ),
    );
  }
}
