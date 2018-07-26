import 'package:austin_feeds_me/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:austin_feeds_me/util/color_util.dart';

String colorPrimary = "#3F51B5";

void main() {
  runApp(new AustinFeedsMeApp());
}

class AustinFeedsMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Austin Feeds Me',
      theme: _austinFeedsMeTheme,
      home: new HomeView(title: "Austin Feeds Me"),
    );
  }
}

final ThemeData _austinFeedsMeTheme = _buildAustinFeedsMeTheme();

ThemeData _buildAustinFeedsMeTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: ColorUtil.hexToColor(colorPrimary),
  );
}
