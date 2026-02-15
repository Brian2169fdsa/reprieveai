import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class WebYoutubePlayer extends StatelessWidget {
  const WebYoutubePlayer({
    super.key,
    required this.videoId,
  });

  final String videoId;

  static final Set<String> _registeredViewTypes = <String>{};

  @override
  Widget build(BuildContext context) {
    final viewType = 'youtube-embed-$videoId';

    if (!_registeredViewTypes.contains(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src = 'https://www.youtube.com/embed/$videoId?rel=0'
          ..style.border = '0'
          ..allow =
              'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
          ..allowFullscreen = true;
        return iframe;
      });
      _registeredViewTypes.add(viewType);
    }

    return HtmlElementView(viewType: viewType);
  }
}
