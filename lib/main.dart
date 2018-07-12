import 'package:austin_feeds_me/views/home_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new AustinFeedsMeApp());
}

class AustinFeedsMeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    return new MaterialApp(
      title: 'Austin Feeds Me',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeView(title: "Austin Feeds Me"),
    );
  }
}

