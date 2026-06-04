import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

class BoltLoginMedia extends StatelessWidget {
  const BoltLoginMedia({
    super.key,
    this.size = 250,
    this.assetPath = 'assets/bolt/boratreinargift.mp4',
  });

  static final _registeredViewTypes = <String>{};

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final viewType = 'bolt-login-video-${assetPath.hashCode}';
    _registerViewFactory(viewType, assetPath);

    return SizedBox(
      width: size,
      height: size,
      child: HtmlElementView(viewType: viewType),
    );
  }

  static void _registerViewFactory(String viewType, String assetPath) {
    if (!_registeredViewTypes.add(viewType)) return;

    ui_web.platformViewRegistry.registerViewFactory(viewType, (viewId) {
      final video = web.document.createElement('video') as web.HTMLVideoElement;
      video
        ..src = _webAssetPath(assetPath)
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..controls = false;

      video.setAttribute('playsinline', 'true');
      video.setAttribute('muted', 'true');
      video.style
        ..width = '100%'
        ..height = '100%'
        ..objectFit = 'cover'
        ..borderRadius = '24px';

      return video;
    });
  }

  static String _webAssetPath(String assetPath) {
    return 'assets/$assetPath';
  }
}
