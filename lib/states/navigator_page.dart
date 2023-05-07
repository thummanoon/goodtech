import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:goodtech/states/coupoung_page.dart';
import 'package:goodtech/states/main_home.dart';
import 'package:goodtech/states/member_page.dart';
import 'package:goodtech/states/noti_page.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_image.dart';

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

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < titles.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: WidgetImage(
            path: paths[i],
            size: 36,
          ),
          label: titles[i],
        ),
      );
    }
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
                appController.indexBodyMobile.value = value;
              },
            ),
          );
        });
  }
}
