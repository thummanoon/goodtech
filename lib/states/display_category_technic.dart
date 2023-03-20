import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/display_profile_technic.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
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
  @override
  void initState() {
    super.initState();
    fineTechnicWhereCategory();
  }

  Future<void> fineTechnicWhereCategory() async {
    if (controller.userModelDisplayTechnic.isNotEmpty) {
      controller.userModelDisplayTechnic.clear();
    }
    await FirebaseFirestore.instance.collection('user').get().then((value) {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        if (userModel.skillTechnic!.contains(widget.category)) {
          controller.userModelDisplayTechnic.add(userModel);
        }
      }
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
              child: WidgetImage(
                path: widget.pathImage,
                size: 36,
              ))
        ],
      ),
      body: GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(
              'userModeldisplay ---> ${appController.userModelDisplayTechnic.length}');
          return appController.userModelDisplayTechnic.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.userModelDisplayTechnic.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Get.to(DisplayProfileTechnic(
                          userModelTechnic: appController.userModelDisplayTechnic[index]));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: WidgetImageInternet(
                              urlPath: appController
                                      .userModelDisplayTechnic[index]
                                      .urlProfile!
                                      .isEmpty
                                  ? AppConstant.urlFreeProfile
                                  : appController.userModelDisplayTechnic[index]
                                      .urlProfile!,
                              width: 60,
                              height: 60,
                            ),
                          ),
                          WidgetText(
                            text: appController
                                .userModelDisplayTechnic[index].name,
                            textStyle: AppConstant().h2Style(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
