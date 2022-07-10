import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  set isDark(bool __isDark) {
    _isDark = __isDark;
    notifyListeners();
  }

  ThemeData get theme => (_isDark) ? _darkTheme : _lightTheme;

  ThemeData _lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(color: Colors.grey),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
      ),
    ),
    primaryIconTheme: IconThemeData(color: Colors.grey),
    cardColor: Colors.grey[300],
  );

  ThemeData _darkTheme = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      cardColor: Color.fromARGB(255, 39, 38, 46));

  final gradientColor = const [
    Color.fromARGB(255, 255, 223, 251),
    Color.fromARGB(255, 223, 250, 255)
  ];

  final gradientAccentColor = const [
    Color.fromARGB(255, 255, 73, 231),
    Color.fromARGB(255, 62, 226, 255)
  ];
}
