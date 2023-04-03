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
  )
);

final ThemeData lightTheme = ThemeData(
  colorSchemeSeed: const Color (0xFF34475C),
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
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: UIColors.black,
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

final ThemeData darkTheme = ThemeData(
  colorSchemeSeed: const Color (0xFF34475C),
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