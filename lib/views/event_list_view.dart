import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListView extends StatefulWidget {

  @override
  _EventListViewState createState() => new _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  List<AustinFeedsMeEvent> events = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('events')
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
              url: data[key]['event_url']));
        }
      }
      setState(() {
        events.sort((a, b) {
          return a.time.compareTo(b.time);
        });
        print("allData length is: " + events.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: events.length == 0
              ? new Center(child: new Text('Loading...'))
              : new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (_, index) {
              return _buildRow(events[index]);
            },
          )),
    );
  }

  Widget _buildRow(AustinFeedsMeEvent event) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.time);
    String date = new DateFormat.MMMMd().format(dateTime);
    String time = new DateFormat.jm().format(dateTime);

    return new GestureDetector(
        child: new Card(
            child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
              ),
              new Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                  ),
                ),
                Image.network(
                  'https://picsum.photos/200?random',
                  width: 77.0,
                  height: 77.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 8.0,
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
              ),
              new Expanded(
                child: new Text(
                  event.name,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              new SizedBox(
                  width: 100.0,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(date,
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                      new Text(time,
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
              ),
            ])),
        onTap: () => eventTapped(event));
  }

  eventTapped(AustinFeedsMeEvent event) {
    _launchURL(event.url);
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}