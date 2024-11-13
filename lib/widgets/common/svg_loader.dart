import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

/// [SVGLoader] this widget is to create an SVG rendering widget from an asset.
/// Use [SVGLoader] like this:
///  ```
/// SVGLoader(
///   image,
///   height: 24,
///   width: 24,
/// )
///  ```
///

class SVGLoader extends StatelessWidget {
  final String image;
  final Color? color;
  final BoxFit fit;

  const SVGLoader({
    super.key,
    required this.image,
    this.color,
    this.fit = BoxFit.contain,
  });
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit,
    );
  }
}
