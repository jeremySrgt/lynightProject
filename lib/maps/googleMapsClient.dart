import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

class GoogleMapsClient extends StatefulWidget {
  void _signOut() {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GoogleMapsState();
  }
}

class _GoogleMapsState extends State<GoogleMapsClient> {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = LatLng(48.856697, 2.3514616);
  final Set<Marker> _markers = {};
  Location location = new Location();
  void placeAllMarkers() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('club').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      _addMarkers(
          snapshot.documents[i]['position'].latitude,
          snapshot.documents[i]['position'].longitude,
          snapshot.documents[i]['name'],
          snapshot.documents[i]['description'],
          snapshot.documents[i].documentID);
    }
  }

  void _addMarkers(latitude, longitude, clubName, clubDesc, clubID) {
    LatLng _nightClubPosition = LatLng(latitude, longitude);
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_nightClubPosition.toString()),
        position: _nightClubPosition,
        infoWindow: InfoWindow(
          title: clubName,
          snippet: clubDesc,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NightClubProfile(
                          documentID: clubID,
                        )));
          },
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<void> _userPosition() async {
    GoogleMapController mapController = await _controller.future;
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 18.0,
    )));
  }

  void _onMapCreated(GoogleMapController controller) {
    location.requestPermission();
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    placeAllMarkers();
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Carte',
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            markers: _markers,
          ),
          Align(
            alignment: Alignment.topRight, // aligne les widget en haut à gauche
            child: Column(
              children: <Widget>[
                SizedBox(height: 3), // sépare distance entre bouton
                FloatingActionButton(
                  //premier bouton qui recentre la position selon _center centre de paris
                  onPressed: _userPosition,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.center_focus_weak, size: 50),
                ),
                SizedBox(height: 30),
//                FloatingActionButton(
//                  // deuxieme bouton ajoute un marker au centre de l'appli
//                  onPressed: _onAddMarkerButtonPressed,
//                  materialTapTargetSize: MaterialTapTargetSize.padded,
//                  backgroundColor: Theme
//                      .of(context)
//                      .primaryColor,
//                  child: const Icon(Icons.add_location, size: 50),
//                ),
              ],
            ),
          ),
        ]),
        constraints: BoxConstraints(
            maxHeight: double.infinity, maxWidth: double.infinity),
      ),
      backgroundColor: Theme.of(context).accentColor,
      drawer: CustomSlider(
        userMail: 'Lalal',
        signOut: widget._signOut,
        activePage: 'Maps',
      ),
    );
  }
}
