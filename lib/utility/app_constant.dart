import 'package:flutter/material.dart';

class AppConstant {
  static var typeUsers = <String>[
    'user',
    'technic',
  ];
  static var typeUserShows = <String>[
    'สมาชิกทั่วไป',
    'ช่างเทคนิค',
  ];

  static String pageAuthen = '/authen';
  static String pageAccountUser = '/accountUser';
  static String pageAccountTeachnic = '/accountTeachnic';

  static Color dark = Colors.black;
  static Color bgColor = Colors.white;

  BoxDecoration borderCurveBox() {
    return BoxDecoration(
      border: Border.all(),borderRadius: BorderRadius.circular(20) 
    );
  }

  BoxDecoration curveBox() {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60), topRight: Radius.circular(60)),
    );
  }

  BoxDecoration imageBox({required String path, double? opacity}) {
    return BoxDecoration(
      image: DecorationImage(
        opacity: opacity ?? 1,
        image: AssetImage(path),
        fit: BoxFit.cover,
      ),
    );
  }

  TextStyle h1Style({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style({Color? color}) {
    return TextStyle(
      fontSize: 20,
      color: color ?? dark,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle h3Style({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}
