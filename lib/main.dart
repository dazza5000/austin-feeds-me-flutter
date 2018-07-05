import 'package:flutter/material.dart';
import 'package:austin_feeds_me/home_view.dart';

void main() => runApp(new AustinFeedsMeApp());

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

