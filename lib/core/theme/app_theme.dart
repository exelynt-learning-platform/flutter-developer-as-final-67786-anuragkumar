import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static final inputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(),
    isDense: true,
  );

  static final chipColor = ThemeData().colorScheme.primary.withValues(alpha: 0.15);
  static final chipTheme = ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      side: BorderSide(color: chipColor)
    ),
  );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.indigo,
      inputDecorationTheme: inputDecorationTheme,
      dialogTheme: dialogTheme,
      cardTheme: const CardThemeData(
        color: Colors.white,
      ),
      chipTheme: chipTheme,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.indigo,
      inputDecorationTheme: inputDecorationTheme,
      dialogTheme: dialogTheme,
      cardTheme: const CardThemeData(
        color: Colors.black,
      ),
      chipTheme: chipTheme,
    );
  }
}
