import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetNotiBadget extends StatelessWidget {
  const WidgetNotiBadget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return badges.Badge(
              badgeContent: WidgetText(
                text: appController.amountNoti.value.toString(),
                textStyle: AppConstant().h3Style(color: Colors.white),
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 36,
                color: Colors.black,
              ));
        });
  }
}
