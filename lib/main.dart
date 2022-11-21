import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/utility/app_constant.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: AppConstant.pageAuthen,
    page: () => const Authen(),
  ),
];


void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: getPages,
      initialRoute: AppConstant.pageAuthen,
    );
  }
}
