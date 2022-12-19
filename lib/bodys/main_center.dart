import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_controller.dart';

import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_text.dart';

class MainCenter extends StatefulWidget {
  const MainCenter({Key? key}) : super(key: key);

  @override
  State<MainCenter> createState() => _MainCenterState();
}

class _MainCenterState extends State<MainCenter> {
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    controller.readBanner();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(
              '##8dec at main_center bannerModels --> ${appController.bannerModels}');
          return ListView(
            children: [
              const WidgetShoehead(head: 'Banner'),
            ],
          );
        });
  }
}
