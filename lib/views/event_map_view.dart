import 'package:austin_feeds_me/data/events_repository.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:flutter/material.dart';
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
    List<Marker> markers = [];

    @override
    void initState() {
      super.initState();

      EventRepository.getEvents().then((List<AustinFeedsMeEvent> events) {
          List<Marker> markers = [];
          for (var currentEvent in events) {
            Marker currentMarker = new Marker(
              width: 77.0,
              height: 77.0,
              point: currentEvent.latLng,
              builder: (ctx) => new Container(
                child: new Text(currentEvent.name),
              ),
            );
            markers.add(currentMarker);
            print("markers location is: " + currentMarker.point.toString());
          }
          setState(() {
          this.markers = markers;
          print("markers length is: " + markers.length.toString());
        });
      });

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
      ),
      new MarkerLayerOptions(markers: markers)]);
    }
}