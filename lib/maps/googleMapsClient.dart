import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleMapsClient extends StatefulWidget {
  GoogleMapsClient({this.onSignOut});
  final VoidCallback onSignOut;
  final BaseAuth auth = new Auth();

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

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
  String userMail = 'userMail';

  @override
  void initState() {
    super.initState();
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
      });
    });
  }

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
        icon: BitmapDescriptor.fromAsset('assets/bloon_final_pin.png'),
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
    _controller.complete(controller);
  }

  Widget googleMapsCreation(){
    return GoogleMap(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    placeAllMarkers();
    location.requestPermission();
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Carte',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Stack(children: <Widget>[
          googleMapsCreation(),
          Align(
            alignment: Alignment.topRight, // aligne les widget en haut à gauche
            child: Column(
              children: <Widget>[
                SizedBox(height: 3), // sépare distance entre bouton
                FloatingActionButton(
                  //premier bouton qui recentre la position selon _center centre de paris
                  onPressed: _userPosition,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.center_focus_weak,
                    size: 35,
                    color: Color(0xFF7854d3),
                  ),
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
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'Maps',
      ),
    );
  }
}
