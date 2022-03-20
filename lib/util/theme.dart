import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  // main colors
  static const Color primaryColor = Color(0xFFE9B171);
  static const Color secondaryColor = Color(0xFFC32285);
  static const Color ternaryColor = Color(0xFF2D9687);

  // font colors
  static const Color fontDarkColor = Color(0xFF323B43);
  static const Color fontLightColor = Color(0xFF888888);

  // other colors
  static const Color backgroundColor = Color(0xFFFFFFFF);

  // theme data
  static ThemeData getAppThemeData() => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Josefin Sans',
        iconTheme: const IconThemeData(color: fontLightColor),
        scrollbarTheme: const ScrollbarThemeData()
            .copyWith(thumbColor: MaterialStateProperty.all(primaryColor)),
        textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.w700,
              color: fontDarkColor,
            ),
            headline2: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 36.0,
              fontWeight: FontWeight.w700,
              color: fontDarkColor,
            ),
            headline3: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: fontDarkColor,
            ),
            headline4: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: fontDarkColor,
            ),
            headline5: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: fontDarkColor,
            ),
            headline6: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: fontDarkColor,
            ),
            bodyText1: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              color: fontLightColor,
            ),
            bodyText2: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: fontLightColor,
            ),
            button: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: fontDarkColor,
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: primaryColor,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            textStyle: const TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: AppTheme.primaryColor),
      );
}
