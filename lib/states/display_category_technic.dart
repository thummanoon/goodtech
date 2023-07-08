import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/province_model.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/display_profile_technic.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';

class DisplayCategoryTechnic extends StatefulWidget {
  const DisplayCategoryTechnic({
    Key? key,
    required this.category,
    required this.pathImage,
  }) : super(key: key);

  final String category;
  final String pathImage;

  @override
  State<DisplayCategoryTechnic> createState() => _DisplayCategoryTechnicState();
}

class _DisplayCategoryTechnicState extends State<DisplayCategoryTechnic> {
  AppController controller = Get.put(AppController());
  bool load = true;
  @override
  void initState() {
    super.initState();
    fineTechnicWhereCategory();
  }

  Future<void> fineTechnicWhereCategory() async {
    if (controller.userModelDisplayTechnic.isNotEmpty) {
      controller.userModelDisplayTechnic.clear();
      controller.provinceModels.clear();
    }
    await FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        if (userModel.skillTechnic!.contains(widget.category)) {
          controller.userModelDisplayTechnic.add(userModel);

          ProvinceModel provinceModel = await AppService().findProvince(
              lat: userModel.geoPoint.latitude,
              lng: userModel.geoPoint.longitude);
          controller.provinceModels.add(provinceModel);
        }
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: widget.category,
          textStyle: AppConstant().h2Style(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 36),
            child: WidgetImageInternet(urlPath: widget.pathImage, width: 36,height: 36,), 
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('provinceModel ---> ${appController.provinceModels.length}');
            return ((appController.userModelDisplayTechnic.isEmpty) ||
                    (appController.provinceModels.isEmpty))
                ? const SizedBox()
                : load
                    ? const WidgetProgress()
                    : ListView.builder(
                        itemCount: appController.userModelDisplayTechnic.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Get.to(DisplayProfileTechnic(
                                userModelTechnic: appController
                                    .userModelDisplayTechnic[index]));
                          },
                          child: Card(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: WidgetImageInternet(
                                      urlPath: appController
                                              .userModelDisplayTechnic[index]
                                              .urlProfile!
                                              .isEmpty
                                          ? AppConstant.urlFreeProfile
                                          : appController
                                              .userModelDisplayTechnic[index]
                                              .urlProfile!,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      WidgetText(
                                        text: appController
                                            .userModelDisplayTechnic[index]
                                            .name,
                                        textStyle: AppConstant().h2Style(),
                                      ),
                                      WidgetText(
                                        text: appController
                                            .provinceModels[index].subdistrict,
                                        textStyle: AppConstant().h3Style(
                                            color: Colors.blue.shade700),
                                      ),
                                      WidgetText(
                                        text: appController
                                            .provinceModels[index].district,
                                        textStyle: AppConstant().h3Style(
                                            color: Colors.green.shade700),
                                      ),
                                      WidgetText(
                                        text: appController
                                            .provinceModels[index].province,
                                        textStyle: AppConstant().h3Style(
                                            color: Colors.red.shade700),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
          },
        );
      }),
    );
  }
}
