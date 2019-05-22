import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'laosjaijsioa',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ImageCarousel(),
    );
  }
}


class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 150,
      child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/nightClub.jpg'),
        AssetImage('assets/boite.jpg'),
        AssetImage('assets/nightClub.jpg'),
        AssetImage('assets/boite.jpg'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 5000),
      ),
    );
  }
}
