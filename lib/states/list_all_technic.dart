import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_text.dart';

import '../utility/app_constant.dart';
import '../utility/app_dialog.dart';
import '../utility/app_service.dart';
import '../widgets/widget_image_internet.dart';
import '../widgets/widget_text_button.dart';
import 'authen.dart';
import 'display_profile_technic.dart';

class ListAllTechnic extends StatefulWidget {
  const ListAllTechnic({Key? key}) : super(key: key);

  @override
  State<ListAllTechnic> createState() => _ListAllTechnicState();
}

class _ListAllTechnicState extends State<ListAllTechnic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: const WidgetText(text: 'รวมช่างและบริการ'),
      ),
      body: GetX(init: AppController(),
        builder: (AppController appController) {
          return GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: appController.technicUserModels.length,
                
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 10 / 12, crossAxisCount: 3),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    if (appController.userModelLogins.isEmpty) {
                      AppDialog(context: context).normalDialog(
                          title: 'ยังไม่ได้ลงชื่อเข้าใช้งาน',
                          detail: 'กรุณา ลงชื่อเข้าใช้งาน',
                          firstBotton: WidgetTextButton(
                            label: 'ลงชื่อเข้าใช้งาน',
                            pressFunc: () {
                              Get.back();
                              Get.to(Authen());
                            },
                          ));
                    } else {
                      Get.to(DisplayProfileTechnic(
                              userModelTechnic:
                                  appController.technicUserModels[index]))!
                          .then((value) {
                        appController.readAllReferance();
                      });
                    }
                  },
                  child: Card(
                    elevation: 7,
                    // color: AppConstant.cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: WidgetImageInternet(
                              width: 100,
                              height: 100,
                              urlPath: appController
                                  .technicUserModels[index].urlProfile!),
                        ),
                        WidgetText(
                          text: AppService().cutWord(
                              word: appController
                                  .technicUserModels[index].name,
                              length: 12),
                          textStyle:
                              AppConstant().h3Style(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              );
        }
      ),
    );
  }
}
