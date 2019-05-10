import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile';


class TopClubCard extends StatelessWidget {

@override
Widget build(BuildContext context) {

  return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 330.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Image.asset(
                          './assets/boite.jpg',
                          fit: BoxFit.cover,
                          height: 240.0,
                          width: 300.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: 180.0,
                    ),
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        width: 250.0,
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Surget\'s Nightclub in Paris',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text('Electro music et Au DD.'),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: FlatButton(
                                    child: Icon(Icons.chevron_right),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/nightClubProfile');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 330.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Image.asset(
                          './assets/boite.jpg',
                          fit: BoxFit.cover,
                          height: 240.0,
                          width: 300.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: 180.0,
                    ),
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        width: 250.0,
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Surget\'s Nightclub in Paris',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('Electro music et Au DD.'),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(top: 50.0),
                                child: FlatButton(
                                  child: Icon(Icons.chevron_right),
                                  onPressed: () {},
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 330.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Image.asset(
                          './assets/boite.jpg',
                          fit: BoxFit.cover,
                          height: 240.0,
                          width: 300.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: 180.0,
                    ),
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        width: 250.0,
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Surget\'s Nightclub in Paris',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('Electro music et Au DD.'),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(top: 50.0),
                                child: FlatButton(
                                  child: Icon(Icons.chevron_right),
                                  onPressed: () {},
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}

}
