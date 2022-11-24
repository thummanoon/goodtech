import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/states/create_account_technic.dart';
import 'package:goodtech/states/create_account_user.dart';
import 'package:goodtech/states/main_home.dart';
import 'package:goodtech/utility/app_constant.dart';

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
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: getPages,
      initialRoute: AppConstant.pageMainHome,
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
