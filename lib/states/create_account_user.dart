import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_logo.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_text.dart';

class CreateAccountUser extends StatelessWidget {
  const CreateAccountUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      // appBar: AppBar(
      //   title: WidgetText(
      //     text: AppConstant.typeUserShows[0],
      //     textStyle: AppConstant().h2Style(),
      //   ),
      // ),
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
                    right: boxConstraints.maxWidth * 0.1,
                    top: boxConstraints.maxWidth * 0.1,
                    child: WidgetImage(
                      size: boxConstraints.maxWidth * 0.2,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 32, right: 32, top: 32),
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight -
                          boxConstraints.maxWidth * 0.4,
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
                          Container(decoration: AppConstant().borderCurveBox(),
                            width: 200,
                            height: 150,
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
