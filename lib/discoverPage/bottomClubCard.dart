import 'package:flutter/material.dart';

Widget bottomClubCard() {
  return Container(
    child: SizedBox(
      height: 230.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Recommandé',
                  style: TextStyle(fontSize: 23.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0)),
                            child: Image.asset(
                              './assets/boite.jpg',
                              fit: BoxFit.cover,
                              height: 115,
                              width: 120.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Cool Club',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0)),
                            child: Image.asset(
                              './assets/boite.jpg',
                              fit: BoxFit.cover,
                              height: 115,
                              width: 120.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Cool Club',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0)),
                            child: Image.asset(
                              './assets/boite.jpg',
                              fit: BoxFit.cover,
                              height: 115,
                              width: 120.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              'Cool Club',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
