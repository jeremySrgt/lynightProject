import 'package:flutter/material.dart';
import 'package:lynight/searchBar/suggestionList.dart';
import 'package:lynight/widgets/slider.dart';

class FavoritesNightClub extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavoritesNightClubState();
  }
}

class _FavoritesNightClubState extends State<FavoritesNightClub> {
  SuggestionList suggestionList;

  Widget _makeListTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                  image: AssetImage('assets/nightClub.jpg'), fit: BoxFit.fill),
              //color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ),
      ),
      title: Text("KellyKellyNightClub",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            Text("3",
                style: TextStyle(
                  color: Colors.white,
                ))
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.music_note, color: Colors.blueAccent),
            Text("Electro", style: TextStyle(color: Colors.white))
          ],
        ),
      ]),
    );
  }

  Card makeCard() => Card(
        color: Colors.transparent,
        elevation: 12.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepOrangeAccent,
                    Theme.of(context).primaryColor,
                  ]),
              //color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/nightClubProfile');
              },
              child: _makeListTile()),
        ),
      );

  Widget _makeBody() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return makeCard();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Card(
          color: Colors.transparent,
          elevation: 12.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: makeCard()),
    );
  }
}
