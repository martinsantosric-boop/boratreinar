import 'package:flutter/widgets.dart';

import 'bolt_video_widget.dart';

class BoltLoginMedia extends StatelessWidget {
  const BoltLoginMedia({
    super.key,
    this.size = 250,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.assetPath = 'assets/bolt/boratreinargift.mp4',
  });

  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return BoltVideoWidget(
      size: size,
      width: width,
      height: height,
      borderRadius: borderRadius,
      assetPath: assetPath,
    );
  }
}
