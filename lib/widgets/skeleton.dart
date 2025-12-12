import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/*
author : Gayathri.B  28/05/2025
description : A customizable shimmering skeleton loader used to represent loading states
              with configurable width, height, and border radius.

 */

class SkeletonLoader extends StatelessWidget {
  // Width and height  of the skeleton box
  final double width;
  final double height;
  // Rounding of corners
  final BorderRadius borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = 150,
    this.height = 50,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
