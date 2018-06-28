import 'package:meta/meta.dart';

class Event {
  Event({
    @required this.name,
    @required this.time,
    this.description,
  });

  final String name;
  final int time;
  final String description;
}
