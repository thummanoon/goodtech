import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/states/display_category_technic.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';

class CategoryTechnic extends StatefulWidget {
  const CategoryTechnic({Key? key}) : super(key: key);

  @override
  State<CategoryTechnic> createState() => _CategoryTechnicState();
}

class _CategoryTechnicState extends State<CategoryTechnic> {
  @override
  void initState() {
    super.initState();
    AppService().readAllTypeTechnic();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('typeuser ---> ${appController.typeUsers.length}');
          return appController.typeTechnicModels.isEmpty
              ? const SizedBox()
              : GridView.builder(
                  itemCount: appController.typeTechnicModels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 4, childAspectRatio: 4/5),
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
                                Get.to(const Authen());
                              },
                            ));
                      } else {
                        Get.to(DisplayCategoryTechnic(
                          category: appController.typeTechnicModels[index].name,
                          pathImage: appController.typeTechnicModels[index].url,
                        ));
                      }
                    },
                    child: Card(
                      color: Colors.green.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // WidgetImage(
                          //   size: 48,
                          //   path: 'images/category$index.png',
                          // ),
                          WidgetImageInternet(urlPath: appController.typeTechnicModels[index].url, width: 48,height: 48,),
                          WidgetText(text: appController.typeTechnicModels[index].name),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
