import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

class AustinFeedsMeEvent {
  AustinFeedsMeEvent({
    @required this.name,
    @required this.time,
    this.description,
    this.url,
    this.photoUrl,
    this.latLng
  });

  final String name;
  final int time;
  final String description;
  final String url;
  final String photoUrl;
  final LatLng latLng;
}
