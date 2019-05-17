import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lynight/widgets/slider.dart';

class GoogleMapsClient extends StatefulWidget {
  void _signOut(){

}
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GoogleMapsState();
  }
}

class _GoogleMapsState extends State<GoogleMapsClient> {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _lastMapPosition = _center;
  static LatLng _initialMapPosition = _center;
  static LatLng _nightClubPosition =
      LatLng(_center.latitude, _center.longitude);
  static LatLng _center = const LatLng(48.856697, 2.3514616);
  final Set<Marker> _markers = {};
  Location location = new Location();

  _userPosition() async {
    GoogleMapController mapController;
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 17.0,
    )));
  }

  final Set<Marker> _addMarkerSearch = {
    //need bdd
    Marker(
      markerId: MarkerId(_nightClubPosition.toString()),
      position: _nightClubPosition,
      infoWindow: InfoWindow(
        title: 'night club name',
        snippet: 'address',
      ),
      icon: BitmapDescriptor.defaultMarker,
    )
  };

  final Set<Marker> _initialPositionMarkers = {
    // initial position
    Marker(
      markerId: MarkerId(_initialMapPosition.toString()),
      position: _initialMapPosition,
      infoWindow: InfoWindow(
        title: 'Ta position frère',
        snippet: 'adresse',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    )
  };

  static final CameraPosition _initialPosition = CameraPosition(
    target: _center,
    zoom: 16,
  );

  Future<void> _recenterCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }

  void _marksPosition(CameraPosition position) {
    _lastMapPosition = position.target; // place un marker cibler au centre
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'la kellykelly nightbox',
          snippet: 'cest gratuit frere \t adresse : dans ton cul ',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontFamily: 'Montserrat'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: _initialPositionMarkers.union(_markers),
            // place un marker sur la carte
            onCameraMove: _marksPosition, // cible la position du marker
          ),
          Align(
            alignment: Alignment.topRight, // aligne les widget en haut à gauche
            child: Column(
              children: <Widget>[
                /*SizedBox(height: 30), // sépare distance entre bouton
                FloatingActionButton(
                  //premier bouton qui recentre la position selon _center centre de paris
                  onPressed: _recenterCamera(),
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.center_focus_weak, size: 50),
                ),*/
                SizedBox(height: 90),
                FloatingActionButton(
                  // deuxieme bouton ajoute un marker au centre de l'appli
                  onPressed: _onAddMarkerButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.add_location, size: 50),
                ),
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
        nameFirstPage: 'Accueil',
        routeFirstPage: '/',
        nameSecondPage: 'Profil',
        routeSecondPage: '/userProfil',
        nameThirdPage: 'Carte',
        routeThirdPage: '/maps',
      ),
    );
  }
}
