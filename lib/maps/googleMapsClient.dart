import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsClient extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GoogleMapsState();
  }
}

class _GoogleMapsState extends State<GoogleMapsClient>{
  GoogleMapController myController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 500.0,
            width: 350.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(48.866667, 2.333333),
                  zoom: 14.4746),
              onMapCreated: (controller){
                setState(() {
                  myController = controller;
                });
              },
            ),
          ),
        ],
      ),

    );
  }
}
