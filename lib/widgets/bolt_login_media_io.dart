import 'package:flutter/widgets.dart';

import 'bolt_video_widget.dart';

class BoltLoginMedia extends StatelessWidget {
  const BoltLoginMedia({
    super.key,
    this.size = 250,
    this.assetPath = 'assets/bolt/boratreinargift.mp4',
  });

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return BoltVideoWidget(size: size, assetPath: assetPath);
  }
}
