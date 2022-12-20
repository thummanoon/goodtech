import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_progress.dart';

import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_text.dart';

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
      widgets.add(WidgetImageInternet(urlPath: element.image));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  '##8dec at main_center bannerModels --> ${appController.bannerModels}');
              return ListView(
                children: [
                  const WidgetShoehead(head: 'Banner'),
                  displayBanner(appController),
                  const WidgetShoehead(head: 'Technicial :'),
                  displayGridTech(appController),
                  const WidgetShoehead(head: 'Referance :'),
                  appController.referanceModels.isEmpty
                      ? const WidgetProgress()
                      : ListView.builder(shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: appController.referanceModels.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              WidgetText(
                                  text: appController.referanceModels[index].nameJob),
                            ],
                          ),
                        ),
                ],
              );
            });
      }
    );
  }

  StatelessWidget displayGridTech(AppController appController) {
    return appController.technicUserModels.isEmpty
        ? const WidgetProgress()
        : GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.technicUserModels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 10 / 12, crossAxisCount: 3),
            itemBuilder: (context, index) => Card(
              color: AppConstant.cardColor,
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
