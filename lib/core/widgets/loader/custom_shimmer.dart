import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double verticalSpacing;
  final double height;
  final int itemCount;

  const CustomShimmer({
    super.key,
    required this.verticalSpacing,
    required this.height,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < itemCount; i++) ...[
          SizedBox(height: verticalSpacing),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
        SizedBox(height: verticalSpacing),
      ],
    );
  }
}
