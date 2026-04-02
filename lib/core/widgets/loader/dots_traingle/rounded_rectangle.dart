import 'package:flutter/material.dart';

class RoundedRectangle extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final bool vertical;
  const RoundedRectangle.vertical({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  }) : vertical = true;

  const RoundedRectangle.horizontal({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  }) : vertical = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          vertical ? width : height,
        ),
      ),
    );
  }
}
