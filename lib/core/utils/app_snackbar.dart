import 'package:flutter/material.dart';

abstract final class AppSnackbar {
  static BuildContext? _context;

  static void bindContext(BuildContext context) {
    _context = context;
  }

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(SnackBar(content: Text(message), duration: duration));
  }

  static void success(String message) {
    _show(SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), behavior: SnackBarBehavior.floating,backgroundColor: Colors.green,));
  }

  static void error(String message) {
    _show(SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), behavior: SnackBarBehavior.floating,backgroundColor: Colors.red));
  }

  static void _show(SnackBar snackBar) {
    final context = _context;
    if (context == null) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger..hideCurrentSnackBar()..showSnackBar(snackBar);
  }
}