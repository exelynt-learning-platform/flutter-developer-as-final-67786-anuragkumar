import 'package:flutter/material.dart';

class ResponsiveVisibility extends StatelessWidget {
  const ResponsiveVisibility({
    required this.mobile,
    super.key,
    this.desktop,
    this.breakpoint = 900,
  });

  final Widget mobile;
  final Widget? desktop;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= breakpoint;

    if (isDesktop) {
      return desktop ?? const SizedBox.shrink();
    }

    return mobile;
  }
}