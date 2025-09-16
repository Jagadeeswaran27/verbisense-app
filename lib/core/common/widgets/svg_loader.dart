import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SVGLoader extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;

  const SVGLoader({
    super.key,
    required this.image,
    this.width = 20,
    this.height = 20,
    this.color,
    this.fit,
  });
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit ?? BoxFit.contain,
      height: height,
      width: width,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
