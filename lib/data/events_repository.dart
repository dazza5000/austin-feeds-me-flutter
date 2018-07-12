import 'dart:async';

import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong/latlong.dart';

class EventRepository {

  static Future<List<AustinFeedsMeEvent>> getEvents() async {
    List<AustinFeedsMeEvent> events = [];

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref.child('events')
        .orderByChild('time')
        .startAt(new DateTime.now().millisecondsSinceEpoch)
        .once()
        .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for (var key in keys) {
        if (data[key]['food']) {
          events.add(new AustinFeedsMeEvent(
              name: data[key]['name'],
              time: data[key]['time'],
              description: data[key]['description'],
              url: data[key]['event_url'],
              photoUrl: _getEventPhotoUrl(data[key]['group']),
          latLng: _getLatLng(data[key])));
        }
      }
    });
    return events;
  }

  static String _getEventPhotoUrl(Map<dynamic, dynamic> data) {
    String defaultImage = "";
    if (data == null) {
      return defaultImage;
    }

    Map<dynamic, dynamic> groupPhotoObject = data['groupPhoto'];
    if (groupPhotoObject == null) {
      return defaultImage;
    }

    String photoUrl = groupPhotoObject['photoUrl'];
    return photoUrl;
  }

  static LatLng _getLatLng(Map<dynamic, dynamic> data) {
    LatLng defaultLocation = new LatLng(0.0, 0.0);
    if (data == null) {
      return defaultLocation;
    }

    Map<dynamic, dynamic> venueObject = data['venue'];
    if (venueObject == null) {
      return defaultLocation;
    }

    return new LatLng(venueObject['lat'], venueObject['lon']);
  }

}