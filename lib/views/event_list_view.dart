import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:austin_feeds_me/data/events_repository.dart';
import 'package:austin_feeds_me/util/url_util.dart';
import 'package:austin_feeds_me/util/image_util.dart';

class EventListView extends StatefulWidget {
  @override
  _EventListViewState createState() => new _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  List<AustinFeedsMeEvent> events = [];

  @override
  void initState() {
    super.initState();

    EventRepository.getEvents().then((List<AustinFeedsMeEvent> events) {
      setState(() {
        this.events = events;
        this.events.sort((a, b) {
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
              ? new Center(child: new CircularProgressIndicator())
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
            child: new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
          ),
          new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
              ),
            ),
            getEventImageWidget(event),
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
              child:
                  new Column(mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(date,
                      style: TextStyle(
                        fontSize: 14.0,
                      )),
                  new SizedBox(width: 4.0),
                  new Text(time,
                      style: TextStyle(
                        fontSize: 14.0,
                      )),
                ]),
            new SizedBox(height: 4.0),
            new Text(event.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0,
              ),
            )
          ]))
        ])),
        onTap: () => eventTapped(event));
  }

  Widget getEventImageWidget(AustinFeedsMeEvent event) {
    return event.photoUrl.isNotEmpty
        ? new CachedNetworkImage(
            imageUrl: event.photoUrl,
            placeholder: Image.asset(
              ImageUtil.getAppLogo(),
              width: 77.0,
              height: 77.0,
            ),
            errorWidget: new Icon(Icons.error),
            width: 77.0,
            height: 77.0,
          )
        : Image.asset(
            ImageUtil.getAppLogo(),
            width: 77.0,
            height: 77.0,
          );
  }

  eventTapped(AustinFeedsMeEvent event) {
//    UrlUtil.launchURL(event.url);
    showModalBottomSheet(context: context, builder: (context){
      return const Text("showModalBottomSheet");
  });
  }
}
