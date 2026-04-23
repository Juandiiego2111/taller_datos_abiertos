import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF003087), // Azul oscuro
          brightness: Brightness.light,
        ).copyWith(
          secondary: const Color(0xFFCE1126), // Rojo
          tertiary: const Color(0xFFFCD116), // Amarillo
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF003087), // Azul oscuro
      foregroundColor: Colors.white, // Texto e íconos blancos
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    // Roboto is the default font in Flutter, so no need to set unless we want to be explicit
    // fontFamily: 'Roboto',
  );
}
