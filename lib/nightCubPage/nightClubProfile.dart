import 'package:flutter/material.dart';

class NightClubProfile extends StatelessWidget {
  @override
    Widget build(BuildContext context) {


    Widget bigRoundedBoxes = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //met dans le bon axe
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16),
                  width: 500, // Dimensions du carré rouge
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Kelly Kelly NightClub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
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
                  padding: const EdgeInsets.only(top: 5),
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
                  padding: const EdgeInsets.only(top: 10),
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
              expandedHeight: 250.0,
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
            upperSection,
            textSection,
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
