import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/services/userData.dart';

class CustomSlider extends StatefulWidget {
  final String userMail;
  Function signOut;
  final String activePage;

  CustomSlider({this.userMail, this.signOut, this.activePage});

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
  bool pro = false;
  int numberOfFriendRequest = 0;

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
        pro = dataMap['pro'];
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
          RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            onPressed: widget.signOut,
          ),
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
          Navigator.pushReplacementNamed(context, '/addClub');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          header(context),
          Container(
            decoration: widget.activePage == 'Accueil'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: widget.activePage == 'Accueil'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Accueil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'Accueil'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          Container(
            decoration: widget.activePage == 'Profil'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: widget.activePage == 'Profil'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'Profil'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/userProfil');
              },
            ),
          ),
          Container(
            decoration: widget.activePage == 'Reservations'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                Icons.book,
                color: widget.activePage == 'Reservations'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Réservations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'Reservations'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/myReservations');
              },
            ),
          ),
          Container(
            decoration: widget.activePage == 'Maps'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.mapMarked,
                color: widget.activePage == 'Maps'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Carte',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'Maps'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/maps');
              },
            ),
          ),
          Container(
            decoration: widget.activePage == 'Amis'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.userFriends,
                color: widget.activePage == 'Amis'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'Amis',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'Amis'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              trailing: numberOfFriendRequest != 0
                  ? Text(
                      numberOfFriendRequest.toString() + ' demande',
                      style: TextStyle(color: Color(0xFFce3737)),
                    )
                  : Text(''),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/friends');
              },
            ),
          ),
          pro == true ? Divider() : Container(),
          pro == true ? scanQrPro() : Container(),
          pro == true ? addClubPro() : Container(),
          Divider(),
          Container(
            decoration: widget.activePage == 'about'
                ? BoxDecoration(
                    color: Color(0xFFebdffc),
                    borderRadius: BorderRadius.circular(15.0))
                : BoxDecoration(),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.infoCircle,
                color: widget.activePage == 'about'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                'À propos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.activePage == 'about'
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
          ),
        ],
      ),
    );
  }
}
