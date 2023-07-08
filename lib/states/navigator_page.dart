import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:goodtech/states/coupoung_page.dart';
import 'package:goodtech/states/main_home.dart';
import 'package:goodtech/states/member_page.dart';
import 'package:goodtech/states/noti_page.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/utility/app_snack_bar.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_noti_badget.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  var bodys = <Widget>[
    const MainHome(),
    const CoupoungPage(),
    const NotiPage(),
    const MemberPage()
  ];

  var items = <BottomNavigationBarItem>[];

  var paths = <String>[
    'images/home2.png',
    'images/coupon.png',
    'images/bell.png',
    'images/logonew.JPG',
  ];
  var titles = <String>[
    'หน้าหลัก',
    'คูปองของฉัน',
    'แจ้งเตือน',
    'สมาชิก',
  ];
  AppController controller = Get.put(AppController());
  @override
  void initState() {
    super.initState();

    checkLogin();

    AppService().realTimePostJob().then((value) {
      print('##8july amountNoti-----> ${controller.amountNoti.value} ');
    });

    for (var i = 0; i < titles.length; i++) {
      items.add(
        i == 2
            ? BottomNavigationBarItem(
                icon: WidgetNotiBadget(), label: titles[i])
            : BottomNavigationBarItem(
                icon: WidgetImage(
                  path: paths[i],
                  size: 36,
                ),
                label: titles[i],
              ),
      );
    }
  }

  bool? statusLogin;

  Future<void> checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        statusLogin = false;
      } else {
        statusLogin = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('indexbody ---> ${appController.indexBodyMobile}');
          return Scaffold(
            body: bodys[appController.indexBodyMobile.value],
            bottomNavigationBar: BottomNavigationBar(
              items: items,
              currentIndex: appController.indexBodyMobile.value,
              selectedItemColor: Colors.green.shade900,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                if (statusLogin ?? false) {
                  appController.indexBodyMobile.value = value;
                  
                } else {
                  AppSnackBar(
                          title: 'กรุณาลงชื่อเข้าใช้งาน',
                          message: 'เฉพาะสมาชิกที่ลงชื่อเข้าใช้งานเท่านั้น')
                      .errorSnackBar();
                }
              },
            ),
          );
        });
  }
}
