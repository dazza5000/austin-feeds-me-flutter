import 'package:meta/meta.dart';

class AustinFeedsMeEvent {
  AustinFeedsMeEvent({
    @required this.name,
    @required this.time,
    this.description,
    this.url
  });

  final String name;
  final int time;
  final String description;
  final String url;
}
