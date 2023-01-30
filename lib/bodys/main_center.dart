import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/states/display_profile_technic.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_progress.dart';

import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
    controller.readTechnicUserModel();
    controller.readAllReferance();
  }

  List<Widget> createWidgets() {
    print('##8dec createWidgetWork');

    var widgets = <Widget>[];
    for (var element in controller.bannerModels) {
      widgets.add(
        WidgetImageInternet(
          urlPath: element.image,
          tapFunc: () async {
            String url = element.link;
            print('url ==> $url');

            Uri uri = Uri.parse(url);
            await canLaunchUrl(uri)
                ? await launchUrl(uri)
                : throw 'cannot OpenUrl';
          },
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('##20dec ref --> ${appController.referanceModels.length}');

            return ListView(
              children: [
                const WidgetShoehead(head: 'Banner'),
                displayBanner(appController),
                const WidgetShoehead(head: 'รวมช่างและบริการ :'),
                displayGridTech(appController),
                const WidgetShoehead(head: 'ผลงานช่างและบริการ :'),
                Divider(
                  color: AppConstant.dark,
                  thickness: 1,
                ),
                listreferance(appController, boxConstraints),
              ],
            );
          });
    });
  }

  StatelessWidget listreferance(
      AppController appController, BoxConstraints boxConstraints) {
    return appController.referanceModels.isEmpty
        ? const WidgetProgress()
        : ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.referanceModels.length,
            itemBuilder: (context, index) => Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: boxConstraints.maxWidth * 0.3,
                      width: boxConstraints.maxWidth * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: WidgetImageInternet(
                              urlPath:
                                  appController.referanceModels[index].urlJob),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: boxConstraints.maxWidth * 0.3,
                      width: boxConstraints.maxWidth * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              text: AppService().cutWord(
                                  word: appController
                                      .referanceModels[index].nameJob,
                                  length: 25),
                              textStyle: AppConstant()
                                  .h3Style(fontWeight: FontWeight.w700),
                            ),
                            WidgetText(
                              text: AppService().dateTimeToString(
                                  dateTime: appController
                                      .referanceModels[index].timestampJob
                                      .toDate()),
                              textStyle:
                                  AppConstant().h3Style(color: Colors.red),
                            ),
                            Row(
                              children: [
                                WidgetImageInternet(
                                    width: 48,
                                    height: 48,
                                    urlPath: appController
                                        .referanceModels[index]
                                        .urlImageTechnic),
                                WidgetText(
                                    text: appController
                                        .referanceModels[index].nameTechnic),
                              ],
                            )
                          ],
                        ),
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
  } // end List

  StatelessWidget displayGridTech(AppController appController) {
    return appController.technicUserModels.isEmpty
        ? const WidgetProgress()
        : GridView.builder(
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
                                  .technicUserModels[index].urlProfile!.isEmpty
                              ? AppConstant.urlFreeProfile
                              : appController
                                  .technicUserModels[index].urlProfile!),
                    ),
                    WidgetText(
                      text: AppService().cutWord(
                          word: appController.technicUserModels[index].name,
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

  Widget displayBanner(AppController appController) {
    return appController.bannerModels.isEmpty
        ? const WidgetProgress()
        : ImageSlideshow(
            children: createWidgets(),
            isLoop: true,
            autoPlayInterval: 5000,
          );
  }
}
