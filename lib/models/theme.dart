import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

const List<Color> colors = [
  Color(0xFF4e5ae8),
  Colors.deepPurple,
  Color(0xFFff4667),
];

const bluishClr = Color(0xFF4e5ae8);
final deepPurpleClr = Colors.deepPurple[500];
const pinkClr = Color(0xFFff4667);
const white = Colors.white;
const primaryColor = bluishClr;
final Color? darkHeaderClr = Colors.grey[800];

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: Colors.grey[900],
    primarySwatch: Colors.grey,
    brightness: Brightness.dark,
  );

  final box = GetStorage();
  final key = 'isDarkMode';

  bool _loadThemeFromBox() => box.read(key) ?? false;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    box.write(key, !_loadThemeFromBox());
  }
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subtitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
  ));
}
