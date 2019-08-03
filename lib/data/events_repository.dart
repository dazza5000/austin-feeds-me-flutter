import 'dart:async';
import 'dart:collection';

import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:austin_feeds_me/data/event_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EventRepository {

  static const EVENT_TABLE_NAME = "event";
  static const String KEY_LAST_FETCH = "last_fetch";
  static const int MILLISECONDS_IN_HOUR = 3600000;
  static const int REFRESH_THRESHOLD = 3 * MILLISECONDS_IN_HOUR;

  static Future<List<AustinFeedsMeEvent>> getEvents() async {
    List<AustinFeedsMeEvent> events = [];

    if (await _shouldRefreshLocalEvents()) {
      events = await _getEventsFromFirestore();
      _setLastRefreshToNow();
      _persistEventsInDatabase(events);
    } else {
      events = await _getEventsFromDatabase();
    }

    return events;
  }

  static Future<List<AustinFeedsMeEvent>> _getEventsFromFirestore() async {
    CollectionReference ref = Firestore.instance.collection('events');
    QuerySnapshot eventsQuery = await ref
        .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
        .where("food", isEqualTo: true)
        .getDocuments();

    HashMap<String, AustinFeedsMeEvent> eventsHashMap = new HashMap<String, AustinFeedsMeEvent>();

    eventsQuery.documents.forEach((document) {
      eventsHashMap.putIfAbsent(document['id'], () => new AustinFeedsMeEvent(
          name: document['name'],
          time: document['time'],
          description: document['description'],
          url: document['event_url'],
          photoUrl: _getEventPhotoUrl(document['group']),
          latLng: _getLatLng(document)));
    });

    return eventsHashMap.values.toList();
  }

  static Future<List<AustinFeedsMeEvent>> _getEventsFromDatabase() async {
    Database dbClient = await EventsDatabase().db;
    List<Map<String, dynamic>> eventRecords = await dbClient.query(EVENT_TABLE_NAME);
    return eventRecords.map((record) => AustinFeedsMeEvent.fromMap(record)).toList();
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

  static Future<bool> _shouldRefreshLocalEvents() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    int lastFetchTimeStamp = prefs.getInt(KEY_LAST_FETCH);

    if (lastFetchTimeStamp == null) {
      print("last timestamp is null");
      return true;
    }

    return(new DateTime.now().millisecondsSinceEpoch - lastFetchTimeStamp) > (REFRESH_THRESHOLD);
  }

  static void _setLastRefreshToNow() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setInt(KEY_LAST_FETCH, new DateTime.now().millisecondsSinceEpoch);
  }

  static void _persistEventsInDatabase(List<AustinFeedsMeEvent> events) async {
    Database dbClient = await EventsDatabase().db;

    dbClient.delete(EVENT_TABLE_NAME);

    events.forEach((event) async {
      int eventId = await dbClient.insert(EVENT_TABLE_NAME, event.toMap());
      print(eventId.toString());
    });
  }

}
