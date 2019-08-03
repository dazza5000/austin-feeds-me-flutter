import 'package:intl/intl.dart';

import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';


class EventUtil {
  static String getEventDateAndTimeDisplayText(AustinFeedsMeEvent austinFeedsMeEvent) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(austinFeedsMeEvent.time);
    String date = new DateFormat.MMMMd().format(dateTime);
    String time = new DateFormat.jm().format(dateTime);
    return date + " " + time;
  }
}