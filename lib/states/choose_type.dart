import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_logo.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ChooseType extends StatefulWidget {
  const ChooseType({Key? key}) : super(key: key);

  @override
  State<ChooseType> createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> {
  var typeUsers = AppConstant.typeUser;
  var typeUserShows = AppConstant.typeUserShows;

  @override
  void initState() {
    super.initState();
    print('typeUserShow = $typeUserShows');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              return Column(
                children: [
                  WidgetLogo(sizeLogo: boxConstraints.maxWidth * 0.35),
                  WidgetText(
                    text: 'เลือกชนิดผู้ใช้งาน',
                    textStyle: AppConstant().h2Style(),
                  ),
                  Container(margin: const EdgeInsets.only(top: 16),
                    width: 250,
                    child: Column(
                      children: [
                        RadioListTile(
                          value: 0,
                          groupValue: appController.indexTypeUser.value,
                          onChanged: (value) {
                            appController.indexTypeUser.value = value!;
                          },
                          title: WidgetText(text: typeUserShows[0]),
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: appController.indexTypeUser.value,
                          onChanged: (value) {
                            appController.indexTypeUser.value = value!;
                          },
                          title: WidgetText(text: typeUserShows[1]),
                        ),
                      ],
                    ),
                  ),
                  WidgetButtom(
                    width: 100,
                    label: 'ยืนยัน',
                    pressFunc: () {},
                  )
                ],
              );
            });
      }),
    );
  }
}
