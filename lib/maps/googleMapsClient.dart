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

class _GoogleMapsState extends State<GoogleMapsClient> {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _lastMapPosition = _center;
  static LatLng _initialMapPosition = _center;

  static LatLng _center = const LatLng(48.859213, 2.339756);

  final Set<Marker> _markers = {};
  final Set<Marker> _initialPositionMarkers = {
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
    tilt: 60,
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
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontFamily: 'Montserrat'),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13,
          ),
          markers: _initialPositionMarkers.union(_markers),
          // place un marker sur la carte
          onCameraMove: _marksPosition, // cible la position du marker
        ),
        Align(
          alignment: Alignment.topRight, // aligne les widget en haut à gauche
          child: Column(
            children: <Widget>[
              SizedBox(height: 30), // sépare distance entre bouton
              FloatingActionButton(
                //premier bouton qui recentre la position selon _center centre de paris
                onPressed: _recenterCamera,
                backgroundColor: Colors.deepOrange,
                child: const Icon(Icons.center_focus_weak, size: 50),
              ),
              SizedBox(height: 30),
              FloatingActionButton(
                // deuxieme bouton ajoute un marker au centre de l'appli
                onPressed: _onAddMarkerButtonPressed,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.deepOrange,
                child: const Icon(Icons.add_location, size: 50),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
