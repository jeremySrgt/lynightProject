import 'package:flutter/material.dart';

class ListReservation extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  // final title = 'Mes reservations';
  //final myReservationList = 'Kelly Kelly';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      color: Theme.of(context).primaryColor,
      home: ListPage(title: 'Lessons'),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(widget.title),

    );

    final makeListTitle = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
        )),
        child: Icon(Icons.music_note, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        'Test Mes reservations',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(Icons.date_range, color: Theme.of(context).primaryColor),
          Text('18/03', style: TextStyle(color: Colors.white))
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 30.0),
    );



    final makeCard = Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTitle,
      ),
    );


    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return makeCard;
        },
      ),
    );



    return Scaffold(
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),//gris
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
/*
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: Container(
                  alignment: Alignment.center,
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/nightClub.jpg'),
                          fit: BoxFit.fill),
                      //color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
              ),
              title: Row(children: <Widget>[
                Text(myReservationList,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              ]),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.music_note, color: Colors.blueAccent),
                  Text(" Type de musique", style: TextStyle(color: Colors.white))
                ],
              ),
              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
              */ /*leading: Icon(Icons.map),
              title: Text('Map'),*/ /*
            ),

          ],
        ),
      ),
    );*/

//}}
