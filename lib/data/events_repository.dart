import 'dart:async';

import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class EventRepository {
  static Future<List<AustinFeedsMeEvent>> getEvents() async {
    List<AustinFeedsMeEvent> events = [];

    CollectionReference ref = Firestore.instance.collection('events');
    QuerySnapshot eventsQuery = await ref
        .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
        .where("food", isEqualTo: true)
        .getDocuments();
    events = eventsQuery.documents.map((document) {
      return new AustinFeedsMeEvent(
          name: document['name'],
          time: document['time'],
          description: document['description'],
          url: document['event_url'],
          photoUrl: _getEventPhotoUrl(document['group']),
          latLng: _getLatLng(document));
    }).toList();

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

  static LatLng _getLatLng(DocumentSnapshot data) {
    LatLng defaultLocation = new LatLng(0.0, 0.0);
    if (data == null) {
      return defaultLocation;
    }

    Map<dynamic, dynamic> venueObject = data['venue'];
    if (venueObject == null) {
      return defaultLocation;
    }

    return new LatLng(
        double.parse(venueObject['lat']), double.parse(venueObject['lon']));
  }
}
