import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class EventMapView extends StatefulWidget {
  EventMapView({Key key}) : super(key: key);

  @override
  _GoogleMaps createState() => new _GoogleMaps();
}

class _GoogleMaps extends State<EventMapView> {
  GoogleMapOverlayController mapOverlayController;

  @override
  void dispose() {
    mapOverlayController.overlayController.deactivateOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    if (mounted) {
      setState(() {
      });
    }
  }

  void buildMap() async {
    if (mapOverlayController != null) return;

    var mq = MediaQuery.of(context);
    // add delay so overlay is positioned correctly
    await new Future<Null>.delayed(new Duration(milliseconds: 20));

    mapOverlayController = GoogleMapOverlayController.fromSize(
      width: mq.size.width,
      height: mq.size.height,
      options: GoogleMapOptions(
        trackCameraPosition: true,
      ),
    );
    mapOverlayController.mapController.addListener(_onMapChanged);
    mapOverlayController.overlayController.activateOverlay();
    setState(() {});
  }

  Widget renderMap() {
    if (mapOverlayController == null) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(
                      "Loading.. please wait...",
                    ),
                  ),
                ),
              ]));
    } else {
      return GoogleMapOverlay(controller: mapOverlayController);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildMap();
    return renderMap();
  }

  void _notifyPop(bool success) {
    mapOverlayController.overlayController.activateOverlay();
  }
}