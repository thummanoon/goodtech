import 'package:flutter/material.dart';

class AppConstant {
  static String urlPromptPay =
      'https://firebasestorage.googleapis.com/v0/b/goodtech-9a4a6.appspot.com/o/admin%2Fqrui-1672729624889.png?alt=media&token=0d9cb7ce-e07a-4886-a707-474b471d9abf';
  static String urlFreeProfile = 'https://firebasestorage.googleapis.com/v0/b/goodtech-9a4a6.appspot.com/o/profile%2F6588863_config_construction_engineer_icon.png?alt=media&token=d86abdbc-a008-41ec-8e8b-e6037ad67be1';
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
  static String pageMainHome = '/mainhome';
  static String pageMainHomeWeb = '/mainhomeWeb';

  static Color dark = Colors.black;
  static Color bgColor = Colors.white;
  static Color cardColor = Color.fromARGB(255, 144, 220, 129);
  static Color chatColor = Colors.indigo;

  BoxDecoration chatRightBox({required BuildContext context}) {
    return BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)));
  }

  BoxDecoration chatLiftBox({required BuildContext context}) {
    return BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius:
            const BorderRadius.only(bottomRight: Radius.circular(10)));
  }

  BoxDecoration borderCurveBox() {
    return BoxDecoration(
        border: Border.all(), borderRadius: BorderRadius.circular(20));
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

  TextStyle h2Style({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 20,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.w700,
    );
  }

  TextStyle h3Style({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 14,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}
