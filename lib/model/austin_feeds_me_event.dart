import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

class AustinFeedsMeEvent {
  static final String columnId = "_id";
  static final String columnName = "name";
  static final String columnTime = "time";
  static final String columnDescription = "description";
  static final String columnUrl = "url";
  static final String columnPhotoUrl = "photo";
  static final String columnLat = "lat";
  static final String columnLng = "lng";

  AustinFeedsMeEvent({
    @required this.name,
    @required this.time,
    this.description,
    this.url,
    this.photoUrl,
    this.latLng,
  });

  final String name;
  final int time;
  final String description;
  final String url;
  final String photoUrl;
  final LatLng latLng;

  Map toMap() {
    Map<String, dynamic> map = {
      columnName: name,
      columnTime: time,
      columnDescription: description,
      columnUrl: url,
      columnPhotoUrl: photoUrl,
      columnLat: latLng.latitude,
      columnLng: latLng.longitude
    };

    return map;
  }

  static AustinFeedsMeEvent fromMap(Map map) {
    return new AustinFeedsMeEvent(
        name: map[columnId],
        time: map[columnTime],
        description: map[columnDescription],
        url: map[columnUrl],
        photoUrl: map[columnPhotoUrl],
        latLng: new LatLng(map[columnLat], map[columnLng]));
  }
}
