import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerColors extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerColors({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: .5),
      highlightColor: Colors.white.withValues(alpha: .3),
      enabled: enabled,
      child: child,
    );
  }
}
