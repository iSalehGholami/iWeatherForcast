// ignore_for_file: non_constant_identifier_names

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {}

class APIConfig extends Constants {
  static final String BaseAPIUrl = "https://api.openweathermap.org";
  static final String GeocodingAPISuffix = "/geo/1.0/direct";
  static final String WeatherForecastAPISuffix = "/data/2.5/weather";
  static final String APIKey = "19aea58fbd4fa88710c98bc4589603a5";
  static final String IconUrlPrefix = "https://openweathermap.org/img/wn/";
  static final String IconUrlSuffix = "@2x.png";
}

class ColorPack extends Constants {
  static const bravoBlue = Color(0xffD2E9E9);
  static const pink = Color(0xffC427FB);

  static const purple1 = Color(0xff5936B4);
  static const purple2 = Color(0xff362A84);

  static const darkpurple1 = Color(0xff2E335A);
  static const darkpurple2 = Color(0xff1C1B33);

  static const alizarinRed = Color(0xffe74c3c);

  static const lightPurpleGradient = LinearGradient(
    colors: [purple1, purple2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkPurpleGradient = LinearGradient(
    colors: [darkpurple1, darkpurple2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme extends Constants {
  AppTheme._();

  /// Light Theme
  static ThemeData lightTheme = FlexThemeData.light(
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    useMaterial3: true,
    scheme: FlexScheme.deepBlue,
    fontFamily: GoogleFonts.roboto().fontFamily,
  );

  /// Dark Theme
  static ThemeData darkTheme = FlexThemeData.dark(
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    swapLegacyOnMaterial3: true,
    useMaterial3: true,
    dialogBackground: Colors.grey.shade900,
    scheme: FlexScheme.indigo,
    tabBarStyle: FlexTabBarStyle.forBackground,
    fontFamily: GoogleFonts.roboto().fontFamily,
  );
}
