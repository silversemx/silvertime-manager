import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final TextTheme theme = GoogleFonts.mPlus2TextTheme().copyWith(
  headline1: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 48
  ),
  headline2: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24
  ),
  headline3: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18
  ),
  headline4: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14
  ),
  bodyText1: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  bodyText2: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400
  ),
  caption: const TextStyle(
      fontSize: 10,
    ),
);

final ThemeData lightTheme = ThemeData(
  colorSchemeSeed: UIColors.primary,
  scaffoldBackgroundColor: UIColors.lightBackground,
  brightness: Brightness.light,
  textTheme: theme.apply(
    bodyColor: UIColors.black,
    displayColor: UIColors.black
  ),
  shadowColor: Colors.black12,
  iconTheme: const IconThemeData(
    color: UIColors.black,
    size: 24
  ),
  dialogTheme: DialogTheme(
    backgroundColor: UIColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderSide:
          const BorderSide(color: UIColors.white),
      borderRadius: BorderRadius.circular(16.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(color: UIColors.white),
      borderRadius: BorderRadius.circular(16.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide (
        color: UIColors.white
      )
    ),
    fillColor: UIColors.lightBackground,
    focusColor: UIColors.lightBackground,
    hintStyle: const TextStyle(
      fontSize: 10,
      color: UIColors.hint,
    ),
    labelStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: UIColors.hint,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData (
    style: ButtonStyle (
      textStyle: MaterialStateProperty.all(
        const TextStyle (
          fontSize: 16,
          color: UIColors.white,
          fontWeight: FontWeight.bold
        )
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder (
          borderRadius: BorderRadius.circular(16)
        ),
      ),
      overlayColor: MaterialStateProperty.all(Colors.transparent)
    )
  ),
  buttonTheme: const ButtonThemeData (
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent
  ),
  textButtonTheme: TextButtonThemeData (
    style: ButtonStyle (
      textStyle: MaterialStateProperty.all(theme.headline3)
    )
  ),
  checkboxTheme: CheckboxThemeData (
    shape: const StadiumBorder ( ),
    fillColor: MaterialStateProperty.all(UIColors.inputSuccess)
  )
);

final ThemeData darkTheme = ThemeData(
  colorSchemeSeed: UIColors.primary,
  brightness: Brightness.dark,
  textTheme: theme.apply(
    bodyColor: UIColors.white,
    displayColor: UIColors.white
  ),
  shadowColor: Colors.grey[900]!,
  iconTheme: const IconThemeData(
    color: UIColors.white,
    size: 24
  ),
  dialogTheme: DialogTheme(
    backgroundColor: UIColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: UIColors.white,
        width: 1
      )
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: UIColors.primary,
        width: 1
      )
    ),
    hintStyle: TextStyle(
      fontSize: 10,
      color: UIColors.hint,
    ),
    labelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: UIColors.hint,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData (
    style: ButtonStyle (
      textStyle: MaterialStateProperty.all(
        const TextStyle (
          fontSize: 16,
          color: UIColors.white,
          fontWeight: FontWeight.bold
        )
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder (
          borderRadius: BorderRadius.circular(16)
        ),
      ),
      overlayColor: MaterialStateProperty.all(Colors.transparent)
    )
  ),
  textButtonTheme: TextButtonThemeData (
    style: ButtonStyle (
      textStyle: MaterialStateProperty.all(theme.headline3)
    )
  )
);