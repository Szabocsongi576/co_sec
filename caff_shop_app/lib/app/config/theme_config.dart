import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeConfig {
  static ThemeData createTheme() {
    return ThemeData(
      colorScheme: ColorScheme(
        primary: ColorConstants.primary,
        primaryVariant: ColorConstants.secondary,
        secondary: ColorConstants.white,
        secondaryVariant: ColorConstants.white,
        surface: ColorConstants.primary,
        background: ColorConstants.white,
        error: ColorConstants.error,
        onPrimary: ColorConstants.white,
        onSecondary: ColorConstants.black,
        onSurface: ColorConstants.black,
        onBackground: ColorConstants.black,
        onError: ColorConstants.white,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        headline1: TextStyle(
          color: ColorConstants.black,
          fontSize: 36.sp * 1.2,
          fontWeight: FontWeight.w600,
        ),
        headline2: TextStyle(
          color: ColorConstants.black,
          fontSize: 24.sp * 1.2,
          fontWeight: FontWeight.normal,
        ),
        headline3: TextStyle(
          color: ColorConstants.black,
          fontSize: 21.sp * 1.2,
          fontWeight: FontWeight.normal,
        ),
        subtitle1: TextStyle(
          color: ColorConstants.black,
          fontSize: 18.sp * 1.2,
          fontWeight: FontWeight.w400,
        ),
        subtitle2: TextStyle(
          color: ColorConstants.black,
          fontSize: 16.sp * 1.2,
          fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
          color: ColorConstants.black,
          fontSize: 15.sp * 1.2,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          color: ColorConstants.black,
          fontSize: 13.sp * 1.2,
          fontWeight: FontWeight.normal,
        ),
        button: TextStyle(
          color: ColorConstants.white,
          fontSize: 15.sp * 1.2,
          fontWeight: FontWeight.w600,
        ),
        caption: TextStyle(
          color: ColorConstants.black,
          fontSize: 11.sp * 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
