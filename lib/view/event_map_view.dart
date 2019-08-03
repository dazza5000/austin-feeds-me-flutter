import 'dart:async';

import 'package:austin_feeds_me/data/events_repository.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:austin_feeds_me/util/image_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:austin_feeds_me/util/url_util.dart';
import 'package:austin_feeds_me/util/event_util.dart';

class EventMapView extends StatefulWidget {
  EventMapView({Key key}) : super(key: key);

  @override
  _Maps createState() => new _Maps();
}

class _Maps extends State<EventMapView> {
  Set<Marker> markers = Set();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition initialMapPosition = CameraPosition(
    target: LatLng(30.26, -97.7),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    EventRepository.getEvents().then((List<AustinFeedsMeEvent> events) {
      Set<Marker> markers = Set();
      for (var currentEvent in events) {

        Marker currentMarker = new Marker(
          markerId: new MarkerId(currentEvent.hashCode.toString()),
          position: currentEvent.latLng,
          onTap: () => onEventClick(currentEvent),
        );

        markers.add(currentMarker);
      }
      setState(() {
        this.markers = markers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GoogleMap(
      mapType: MapType.normal,
      markers: markers,
      initialCameraPosition: initialMapPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  onEventClick(AustinFeedsMeEvent austinFeedsMeEvent) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                new Expanded(
                    child: ImageUtil.getEventImageWidget(
                        austinFeedsMeEvent, 1000.0, 1000.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    EventUtil.getEventDateAndTimeDisplayText(
                        austinFeedsMeEvent),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    austinFeedsMeEvent.name,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    austinFeedsMeEvent.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new FlatButton(
                    onPressed: () => UrlUtil.launchURL(austinFeedsMeEvent.url),
                    child: new Text("RSVP",
                        style: const TextStyle(fontSize: 18.0)),
                    color: Colors.lightBlue,
                  )
                ],
              ));
        });
  }
}
