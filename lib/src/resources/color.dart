import 'package:flutter/material.dart';

class CustomColor {
  static String mblue = '#009EEE';
  
  static String mbluehex = mblue.replaceAll("#", "");
  CustomColor();
  static Color mbluecol =
      Color(int.parse(mbluehex, radix: 16)).withOpacity(1.0);

  static String mred = '#BF0021';
  static String mredhex = mred.replaceAll("#", "");
  static Color mredcol =
      Color(int.parse(mredhex, radix: 16)).withOpacity(1.0);
   
      static String mgrey = '#D6D6D6';
  static String mgreyhex = mgrey.replaceAll("#", "");
  static Color mgreycol =
      Color(int.parse(mgreyhex, radix: 16)).withOpacity(1.0);

  Color get primaryColor => mbluecol;
  Color get accentColor => mredcol;
  Color get greyColor => mgreycol;
}