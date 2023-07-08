import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/states/display_category_technic.dart';
import 'package:goodtech/states/display_profile_technic.dart';
import 'package:goodtech/states/list_all_technic.dart';
import 'package:goodtech/states/post_job_member.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_image.dart';
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
    AppService().readAllTypeTechnic();
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
            print(
                'typeuser at Main Center ---> ${appController.typeUsers.length}');

            return ListView(
              children: [
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        displayBanner(appController),
                        const SizedBox(
                          height: 12,
                        ),
                        const WidgetShoehead(head: 'รวมช่างและบริการ'),
                      ],
                    ),
                    Positioned(
                      top: 165,
                      child: SizedBox(
                        width: boxConstraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WidgetButtom(
                              fontWeight: FontWeight.w700,
                              textColor: Colors.black,
                              color: Colors.white,
                              label: 'เรียกรถพยาบาล\n         1669',
                              pressFunc: () async {
                                const url = 'tel:1669';
                                Uri uri = Uri.parse(url);
                                await canLaunchUrl(uri)
                                    ? await launchUrl(uri)
                                    : throw 'Cannot';
                              },
                            ),
                            WidgetButtom(
                              textColor: Colors.black,
                              color: Colors.white,
                              label: 'ประกาศงานหาช่าง',
                              pressFunc: () {
                                if (appController.userModelLogins.isEmpty) {
                                  AppDialog(context: context).normalDialog(
                                      title: 'ยังไม่ได้ลงชื่อเข้าใช้งาน',
                                      detail: 'กรุณา ลงชื่อเข้าใช้งาน',
                                      firstBotton: WidgetTextButton(
                                        label: 'ลงชื่อเข้าใช้งาน',
                                        pressFunc: () {
                                          Get.back();
                                          Get.to(const Authen());
                                        },
                                      ));
                                } else {
                                  Get.to(const PostJobMember());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                appController.typeTechnicModels.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: appController.typeTechnicModels.length,
                          itemBuilder: (context, index) => SizedBox(
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                if (appController.userModelLogins.isEmpty) {
                                  AppDialog(context: context).normalDialog(
                                      title: 'ยังไม่ได้ลงชื่อเข้าใช้งาน',
                                      detail: 'กรุณา ลงชื่อเข้าใช้งาน',
                                      firstBotton: WidgetTextButton(
                                        label: 'ลงชื่อเข้าใช้งาน',
                                        pressFunc: () {
                                          Get.back();
                                          Get.to(const Authen());
                                        },
                                      ));
                                } else {
                                  Get.to(DisplayCategoryTechnic(
                                    category: appController
                                        .typeTechnicModels[index].name,
                                    pathImage: appController
                                        .typeTechnicModels[index].url,
                                  ));
                                }
                              },
                              child: Card(
                                color: Colors.green.shade100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetImageInternet(
                                      urlPath: appController
                                          .typeTechnicModels[index].url,
                                      width: 48,
                                      height: 48,
                                    ),
                                    WidgetText(
                                        text: appController
                                            .typeTechnicModels[index].name),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                displayGridTech(appController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WidgetTextButton(
                      label: 'ดูทั้งหมด',
                      pressFunc: () {
                        Get.to(const ListAllTechnic());
                      },
                    ),
                  ],
                ),
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
                                  length: 20),
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
                                CachedNetworkImage(
                                  width: 48,
                                  height: 48,
                                  imageUrl: appController
                                      .referanceModels[index].urlImageTechnic,
                                  errorWidget: (context, url, error) =>
                                      WidgetImageInternet(
                                          urlPath: AppConstant.urlFreeProfile),
                                ),
                                WidgetText(
                                    text: AppService().cutWord(
                                        word: appController
                                            .referanceModels[index].nameTechnic,
                                        length: 20)),
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
            // itemCount: appController.technicUserModels.length,
            itemCount: 6,
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
                              .haveImagetechnicUserModels[index].urlProfile!),
                    ),
                    WidgetText(
                      text: AppService().cutWord(
                          word: appController
                              .haveImagetechnicUserModels[index].name,
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
