import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:lynight/discoverPage/discoverTab.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'lynight',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: DiscoverTab(),
    );
  }
}
