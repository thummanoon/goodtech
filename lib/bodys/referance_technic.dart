import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/app_referance.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_false_page.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ReferanceTechnic extends StatefulWidget {
  const ReferanceTechnic({Key? key}) : super(key: key);

  @override
  State<ReferanceTechnic> createState() => _ReferanceTechnicState();
}

class _ReferanceTechnicState extends State<ReferanceTechnic> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##8dec referanceModels --> ${appController.referanceModels}');
            return SizedBox(
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Stack(
                children: [
                  appController.loadReferance.value
                      ? const WidgetProgress()
                      : appController.referanceModels.isEmpty
                          ? const WidgetFalsePage(label: 'No Referance')
                          : WidgetText(text: 'have referance'),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: WidgetButtom(
                      label: 'Add Referance',
                      pressFunc: () {
                        Get.to(const AddReferance());
                      },
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
