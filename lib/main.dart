import 'package:austin_feeds_me/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
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

