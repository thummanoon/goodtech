import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/app_referance.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_false_page.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ReferanceTechnic extends StatefulWidget {
  const ReferanceTechnic({Key? key}) : super(key: key);

  @override
  State<ReferanceTechnic> createState() => _ReferanceTechnicState();
}

class _ReferanceTechnicState extends State<ReferanceTechnic> {
  AppController controller = Get.put(AppController());
  @override
  void initState() {
    super.initState();
    controller.readTechReferance();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##20mar userModelLogins --> ${appController.userModelLogins.length}');
            return SizedBox(
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Stack(
                children: [
                  appController.loadReferance.value
                      ? const WidgetProgress()
                      : appController.referanceModels.isEmpty
                          ? const WidgetFalsePage(label: 'No Referance')
                          : listReferance(appController, boxConstraints),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: WidgetButtom(
                      label: 'Add Referance',
                      pressFunc: () {
                        if (appController
                                .userModelLogins.last.urlProfile?.isEmpty ??
                            true) {
                          AppDialog(context: context).normalDialog(
                              title: 'ยังไม่มีรูป profile',
                              detail: 'กรุณาเพิ่มรูป profile ก่อน',
                              firstBotton: WidgetButtom(
                                label: 'แก้ไข profile',
                                pressFunc: () {
                                  Get.back();
                                  appController.indexBody.value = 2;
                                },
                              ));
                        } else {
                          Get.to(const AddReferance())!.then((value) {
                            controller.readTechReferance();
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          });
    });
  }

  ListView listReferance(
      AppController appController, BoxConstraints boxConstraints) {
    return ListView.builder(
      itemCount: appController.referanceModels.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: boxConstraints.maxWidth * 0.4,
                height: boxConstraints.maxWidth * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: WidgetImageInternet(
                      urlPath: appController.referanceModels[index].urlJob),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: boxConstraints.maxWidth * 0.6,
                height: boxConstraints.maxWidth * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(
                        text: AppService().cutWord(
                            word: appController.referanceModels[index].nameJob,
                            length: 25),
                        textStyle:
                            AppConstant().h3Style(fontWeight: FontWeight.bold)),
                    WidgetText(
                        text: AppService().cutWord(
                            word: appController.referanceModels[index].detail,
                            length: 80)),
                    const Spacer(),
                    WidgetText(
                      text: AppService().dateTimeToString(
                        dateTime: appController
                            .referanceModels[index].timestampJob
                            .toDate(),
                      ),
                      textStyle: AppConstant().h3Style(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: AppConstant.dark,
            thickness: 1,
          ),
        ],
      ),
    );
  } //end List
}
