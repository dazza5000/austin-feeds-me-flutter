import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:flutter/material.dart';
import 'package:austin_feeds_me/data/events_repository.dart';
import 'package:austin_feeds_me/util/url_util.dart';
import 'package:austin_feeds_me/util/image_util.dart';
import 'package:austin_feeds_me/util/event_util.dart';

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
              : new ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: events.length,
                  itemBuilder: (_, index) {
                    return _buildRow(events[index]);
                  },
                )),
    );
  }

  Widget _buildRow(AustinFeedsMeEvent event) {
    return new GestureDetector(
        child: new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.circular(4.0),
              child: ImageUtil.getEventImageWidget(event, 80.0, 80.0),
            ),
          ]),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          new Expanded(
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                new Text(
                  EventUtil.getEventDateAndTimeDisplayText(event),
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                new SizedBox(height: 4.0),
                new Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ]))
        ]),
        onTap: () => eventTapped(event));
  }

  eventTapped(AustinFeedsMeEvent event) {
    UrlUtil.launchURL(event.url);
  }
}
