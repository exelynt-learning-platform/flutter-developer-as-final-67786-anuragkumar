import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.desktop,
    super.key,
    this.breakpoint = 900,
  });

  final Widget mobile;
  final Widget? desktop;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return desktop ?? SizedBox.shrink();
        }
        return mobile;
      },
    );
  }
}