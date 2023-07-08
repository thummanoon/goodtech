import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/states/create_account_technic.dart';
import 'package:goodtech/states/create_account_user.dart';
import 'package:goodtech/states/main_home.dart';
import 'package:goodtech/states/main_home_web.dart';
import 'package:goodtech/states/navigator_page.dart';
import 'package:goodtech/states/upgrade_alert_page.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: AppConstant.pageMainHome,
    page: () => const MainHome(),
  ),
  GetPage(
    name: AppConstant.pageAuthen,
    page: () => const Authen(),
  ),
  GetPage(
    name: AppConstant.pageAccountUser,
    page: () => const CreateAccountUser(),
  ),
  GetPage(
    name: AppConstant.pageAccountTeachnic,
    page: () => const CreateAccountTeachnic(),
  ),
  GetPage(
    name: AppConstant.pageMainHomeWeb,
    page: () => const MainHomeWeb(),
  ),
  GetPage(
    name: '/navigator',
    page: () => const NavigatorPage(),
  ),
  GetPage(name: '/upgrade', page: () => const UpgradeAlertPage(),)
];

// String firstState = AppConstant.pageMainHome;
String firstState = '/upgrade';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDd-zG0bMhWBPQKm9GyqfVp40qFSJPGjcc',
          appId: '1:1098864961054:web:11cb1b88e5f5943b16700f',
          messagingSenderId: '1098864961054',
          projectId: 'goodtech-9a4a6'),
    ).then((value) {
      firstState = AppConstant.pageMainHomeWeb;
      runApp(const MyApp());
    });
  } else {
    //mobile

    await Firebase.initializeApp().then((value) {
      runApp(const MyApp());
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      initialRoute: firstState,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: AppConstant.bgColor,
          foregroundColor: AppConstant.dark,
          elevation: 0,
        ),
      ),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
