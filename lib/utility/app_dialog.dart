import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void normalDialog({
    required String title,
    required String detail,
    Widget? iconWidget,
    Widget? firstBotton,
    Widget? secondBotton,
  }) {
    Get.dialog(
      AlertDialog(
        icon: Center(
          child: iconWidget ??
              const WidgetImage(
                size: 100,
              ),
        ),
        title: WidgetText(
          text: title,
          textStyle: AppConstant().h2Style(),
        ),
        content: WidgetText(text: detail),
        actions: [
          firstBotton ?? const SizedBox(),
          secondBotton ??
              WidgetTextButton(
                label: 'OK',
                pressFunc: () {
                  Get.back();
                },
              )
        ],
      ),
    );
  }
}
