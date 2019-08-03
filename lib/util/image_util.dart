import 'package:flutter/material.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUtil {
  static String getAppLogo() {
    return 'assets/ic_logo.png';
  }

  static Widget getEventImageWidget(AustinFeedsMeEvent event, double width, double height) {
    return event.photoUrl.isNotEmpty
        ? new CachedNetworkImage(
      fit: BoxFit.fitWidth,
      imageUrl: event.photoUrl,
      placeholder: (context, url) => Image.asset(
        ImageUtil.getAppLogo(),
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      width: width,
      height: height,
    )
        : Image.asset(
      ImageUtil.getAppLogo(),
      width: width,
      height: height,
    );
  }
}
