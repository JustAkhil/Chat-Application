import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors{

  ///dark theme
  static Color mainBlack = Color(0xff0E0E0E);
  static Color semiBlack = Color(0xff242424);
  static Color mediumBlack = Color(0xff2F2F2F);
  static Color lightBlack = Color(0xff575757);
  static Color greyBlack = Color(0xff424040);
  static Color secondaryBlueColor = Color(0xff9ED1D9);
  static Color secondaryDarkBlueColor = Color(0xff2ac6de);


  ///light theme
  static Color mainWhite = Color(0xffFFFFFF);
  static Color semiWhite = Color(0xffF5F5FC);
  static Color mediumWhite = Color(0xffADA9BD);
  static Color lightWhite = Color(0xff918EAA);
  static Color greyWhite = Color(0xffa8a3a3);
  static Color secondaryWhiteColor = Color(0xffb1e9f2);

  static Color secondaryYellowColor = Color(0xffFEEA97);
  static Color secondaryGreenColor = Color(0xffCCEAB7);


}

TextStyle mTextStyle16(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 16,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}

TextStyle mTextStyle12(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 12,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}

TextStyle mTextStyle10(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 10,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}

TextStyle mTextStyle22(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 22,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}