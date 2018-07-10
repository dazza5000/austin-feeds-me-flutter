import 'package:flutter/material.dart';
import 'package:austin_feeds_me/model/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';



class EventMapView extends StatefulWidget {
  EventMapView({Key key}) : super(key: key);

  @override
  _Maps createState() => new _Maps();
}

//final LatLngBounds sydneyBounds = LatLngBounds(
//  southwest: const LatLng(-34.022631, 150.620685),
//  northeast: const LatLng(-33.571835, 151.325952),
//);
//
//final LatLng austinLatLng = new LatLng(30.2669444, -97.7427778);

class _Maps extends State<EventMapView> {
    List<Location> locations = List<Location>();

    @override
    void initState() {
      locations.add(Location(
          id: 1,
          name: 'Sydney Opera House',
          address1: 'Bennelong Point',
          address2: 'Sydney NSW 2000, Australia',
          lat: '-33.856159',
          long: '151.215256',
          imageUrl:
          'https://www.planetware.com/photos-large/AUS/australia-sydney-opera-house-2.jpg'));
      locations.add(Location(
          id: 2,
          name: 'Sydney Harbour Bridge',
          address1: '',
          address2: 'Sydney NSW, Australia',
          lat: '-33.857013',
          long: '151.207694',
          imageUrl:
          'https://www.planetware.com/photos-large/AUS/australia-sydney-harbour-bridge.jpg'));
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return  new FlutterMap(
          options: new MapOptions(
          center: new LatLng(30.2669444, -97.7427778),
      zoom: 12.0,
      ),
      layers: [
      new TileLayerOptions(
      urlTemplate:
      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
      )]);
    }
}