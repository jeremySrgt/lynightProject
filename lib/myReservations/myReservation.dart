import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/myReservations/reservation.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/myReservations/detailReservation.dart';
import 'package:lynight/authentification/auth.dart';


class ListPage extends StatefulWidget {


  void _signOut() {


  }

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List reservations;

  @override
  void initState() {
    reservations = getReservations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text('Mes reservations'),
    );

    ListTile makeListTitle(Reservation reservation) =>
      ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
              border: Border(
                right:
                BorderSide(width: 1.0, color: Theme
                    .of(context)
                    .primaryColor),
              )),
          child:
          Icon(Icons.music_note, color: Theme
              .of(context)
              .primaryColor),
        ),
        title: Text(
          'Test Mes reservations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColor,
                  size: 20.0
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  '18/03',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16.0
                  ),
                ),
              ),
            )
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 25.0),
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => DetailPage(reservation: reservation)),
          );
        },
      );


    Card makeCard(Reservation reservation) =>
        Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTitle(reservation),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reservations.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(reservations[index]);
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),//gris
      appBar: topAppBar,

      body: makeBody,
      drawer: CustomSlider(
        userMail: 'Lalal',
        signOut: widget._signOut,
        nameFirstPage: 'Accueil',
        routeFirstPage: '/',
        nameSecondPage: 'Profil',
        routeSecondPage: '/userProfil',
        nameThirdPage: 'Carte',
        routeThirdPage: '/maps',
      ),
    );
  }

  List getReservations() {
    return [
      Reservation(title: 'Kelly Kelly', date: '18/02'),
      Reservation(
        title: 'Jeremy\'s night club',
        date: '03/04',
      ),
      Reservation(
        title: 'Sysy\' club',
        date: '15/05',
      ),
    ];
  }
}
