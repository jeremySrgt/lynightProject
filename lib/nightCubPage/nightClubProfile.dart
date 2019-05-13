import 'package:flutter/material.dart';

class NightClubProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget infoSection = Expanded(
      child: Row(
        children: [
          Expanded(
            //margin: EdgeInsets.only(left: 50),
           // width: 275,
            //height: 150,
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              //color: Colors.blueGrey,
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              ),
            ),*/
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //met dans le bon axe
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 40,
                  child: Text(
                    'Informations\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Text(
                    'Kelly Kelly NightClub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.place,
                        size: 17,
                      ),
                      Text(
                        '   Paris 13ème ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.amber,
                        size: 17,
                      ),
                      Text(
                        '   0101010010',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.insert_link,
                        size: 17,
                        color: Colors.blue,
                      ),
                      Text(
                        '   www.kellyKelly.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );


    Widget musicSection = Expanded(
      child: Row(
        children: [
          Expanded(
            //margin: EdgeInsets.fromLTRB(50, 15, 0,0),
            //width: 275,
            //height: 150,
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              //color: Colors.blueGrey,
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              ),
            ),*/
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start, //met dans le bon axe
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 50,
                  child: Text(
                    'Musique\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.music_note,
                        color: Colors.amber,
                        size: 17,
                      ),
                      Text(
                        '   Style de Musique : Electro',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.queue_music,
                        size: 17,
                        color: Colors.blue,
                      ),
                      Text(
                        '   www.soundcloud.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget upperSection = Container(
      padding: const EdgeInsets.all(20), //offset de 50
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //met dans le bon axe
              children: [

                Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.music_note,
                        color: Colors.amber,
                        size: 17,
                      ),
                      Text(
                        '   Style de Musique : Electro',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.queue_music,
                        size: 17,
                        color: Colors.blue,
                      ),
                      Text(
                        '   www.soundcloud.com',
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '50 ',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.only(bottom: 10, left: 20),
      child: Text(
        'Du mercredi au samedi, de 23h à 6h du matin, nous vous proposons : strip-teases, lap dance, table dance et shows privés.\n',
        softWrap: true,
      ),
    );

    Widget priceSection = Container(
      padding: const EdgeInsets.only(left: 150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const RaisedButton(
            onPressed: null,
            child: Text(
              'Let\'s party',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    // TODO: implement build
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Kelly Kelly NightClub",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.asset(
                    'assets/boite.jpg',
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            infoSection,
            musicSection,
            priceSection,
          ],
        ),
      ),
    );
    /*return Scaffold(
      body: Column(
        children: [
          Stack(children: <Widget>[
            Hero(
              tag: 'club',
              child: Image.asset(
                'assets/boite.jpg',
                width: 500,
                height: 250,
                fit: BoxFit.cover, //as small as possible but take all the place
              ),
            ),
            SafeArea(
              child: FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.deepOrange,
                  size: 30.0,
                ),
                onPressed: () {
//                  Navigator.pushNamed(context, '/');
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
          bigRoundedBoxes,
        ],
      ),
    );*/
  }
}
