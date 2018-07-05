import 'package:flutter/material.dart';
import 'package:austin_feeds_me/views/home_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  //GoogleMapController.init();
  runApp(new AustinFeedsMeApp());
}

class AustinFeedsMeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Austin Feeds Me',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeView(title: "Austin Feeds Me"),
    );
  }
}

