import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_logo.dart';

class Authen extends StatelessWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              return ListView(
                children: [
                  WidgetLogo(
                    sizeLogo: boxConstraints.maxWidth * 0.35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetForm(
                        hint: 'Email :',
                        changeFunc: (p0) {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetForm(
                        obscecu: appController.redEye.value,
                        hint: 'Password :',
                        changeFunc: (p0) {},
                        suffixWidget: WidgetIconButton(
                          iconData: appController.redEye.value ? Icons.remove_red_eye : Icons.remove_red_eye_outlined ,
                          pressFunc: () {
                            appController.redEye.value =
                                !appController.redEye.value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
      }),
    );
  }
}
