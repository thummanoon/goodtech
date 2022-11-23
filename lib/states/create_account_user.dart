import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_google_map.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';

import '../utility/app_service.dart';

class CreateAccountUser extends StatefulWidget {
  const CreateAccountUser({Key? key}) : super(key: key);

  @override
  State<CreateAccountUser> createState() => _CreateAccountUserState();
}

class _CreateAccountUserState extends State<CreateAccountUser> {
  Position? position;

  @override
  void initState() {
    super.initState();
    findPosition();
  }

  Future<void> findPosition() async {
    await AppService().processFindPosition(context: context).then((value) {
      position = value;
      print('position = ${position.toString()}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            return Container(
              decoration:
                  AppConstant().imageBox(path: 'images/bg1.jpg', opacity: 0.6),
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Stack(
                children: [
                  WidgetMenu(
                      leadWidget: WidgetIconButton(
                        iconColor: AppConstant.dark,
                        iconData: Icons.arrow_back,
                        pressFunc: () {
                          Get.back();
                        },
                      ),
                      title: AppConstant.typeUserShows[0]),
                  Positioned(
                    right: boxConstraints.maxWidth * 0.05,
                    top: boxConstraints.maxWidth * 0.02,
                    child: WidgetImage(
                      size: boxConstraints.maxWidth * 0.3,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 32, right: 32, top: 32),
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight -
                          boxConstraints.maxWidth * 0.40,
                      decoration: AppConstant().curveBox(),
                      child: ListView(
                        children: [
                          WidgetText(
                            text: 'ข้อมูลสมาชิก :',
                            textStyle: AppConstant().h2Style(),
                          ),
                          WidgetForm(
                            labelWidget: WidgetText(text: 'ชื่อ-นามสกุล'),
                            changeFunc: (p0) {},
                          ),
                          WidgetForm(
                            labelWidget: WidgetText(text: 'ที่อยู่'),
                            changeFunc: (p0) {},
                          ),
                          WidgetForm(
                            labelWidget: WidgetText(text: 'เบอร์โทรศัพท์'),
                            changeFunc: (p0) {},
                          ),
                          WidgetForm(
                            labelWidget: WidgetText(text: 'Email'),
                            changeFunc: (p0) {},
                          ),
                          WidgetForm(
                            labelWidget: WidgetText(text: 'Password'),
                            changeFunc: (p0) {},
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: WidgetText(
                              text: 'พิกัด :',
                              textStyle: AppConstant().h2Style(),
                            ),
                          ),
                          Container(padding:  const EdgeInsets.all(4),
                            decoration: AppConstant().borderCurveBox(),
                            width: 200,
                            height: 180,
                            child: position == null
                                ? const WidgetProgress()
                                : WidgetGoogleMap(
                                    lat: position!.latitude,
                                    lng: position!.longitude),
                          ),
                          WidgetButtom(
                            label: 'ยืนยัน',
                            pressFunc: () {},
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
