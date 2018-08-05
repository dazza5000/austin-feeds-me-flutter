import 'package:austin_feeds_me/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:austin_feeds_me/util/color_util.dart';

String colorPrimary = "#3F51B5";
String appName = "Flutter Feeds Me #FlutterDev";

void main() {
  runApp(new AustinFeedsMeApp());
}

class AustinFeedsMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      theme: _austinFeedsMeTheme,
      home: new HomeView(title: appName),
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
