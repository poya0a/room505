import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';

ThemeData lightTheme = ThemeData(
  canvasColor: Palette.mainColor,
  primaryColorLight: Palette.subColor,
  scaffoldBackgroundColor: Palette.backgroundColor,
  dialogBackgroundColor: Palette.chatBackground,
  shadowColor: Palette.borderColor,
  textTheme: TextTheme(
    headline1: TextStyle(color: Palette.blueColor),
    bodyText1: TextStyle(color: Palette.text),
    bodyText2: TextStyle(color: Palette.textSub),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  canvasColor: Color.fromRGBO(11, 11, 49, 1),
  primaryColorLight: Color.fromRGBO(11, 11, 49, .5),
  scaffoldBackgroundColor: Palette.text,
  dialogBackgroundColor: Palette.text2,
  shadowColor: Palette.textSub,
  textTheme: TextTheme(
    headline1: TextStyle(color: Palette.subColor),
    bodyText1: TextStyle(color: Palette.backgroundColor),
    bodyText2: TextStyle(color: Palette.chatBackground),
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;

  void toggleTheme() {
    currentTheme = currentTheme == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}
