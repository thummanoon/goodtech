import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/post_model.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_show_profile.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  AppController appController = Get.put(AppController());
  PageController? pageController;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService().findUserModelLogin().then((value) {
      print(
          '##28feb userModel at List page ---> ${appController.userModelLogins.length}');
    });

    AppService().readFirstReferance().then((value) {
      print(
          '##28feb referenceModel ---> ${appController.referanceModels.length}');

      pageController =
          PageController(initialPage: appController.indexPage.value);

      AppService().readPost(
          docIdReferance:
              appController.docReferances[appController.indexPage.value]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return Obx(() {
          return appController.referanceModels.isEmpty
              ? const SizedBox()
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: appController.referanceModels.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: Stack(
                      children: [
                        WidgetImageInternet(
                          urlPath: appController.referanceModels[index].urlJob,
                          width: boxConstraints.maxWidth,
                          height: boxConstraints.maxHeight,
                        ),
                        Positioned(
                          top: 48,
                          left: 16,
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: boxConstraints.maxWidth - 90),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black38),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetShowProfile(
                                    urlImage: appController
                                        .referanceModels[index]
                                        .urlImageTechnic),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: boxConstraints.maxWidth * 0.55,
                                      child: WidgetText(
                                        text: appController
                                            .referanceModels[index].nameTechnic,
                                        textStyle: AppConstant()
                                            .h2Style(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: boxConstraints.maxWidth * 0.55,
                                      child: WidgetText(
                                        text: appController
                                            .referanceModels[index].nameJob,
                                        textStyle: AppConstant().h3Style(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: boxConstraints.maxWidth * 0.55,
                                      child: WidgetText(
                                        text: appController
                                            .referanceModels[index].detail,
                                        textStyle: AppConstant()
                                            .h3Style(color: Colors.red),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          right: 36,
                          child: WidgetIconButton(
                            iconData: Icons.home,
                            pressFunc: () {
                              Get.offAllNamed('/navigator');
                            },
                            size: 48,
                            iconColor: Colors.yellow,
                          ),
                        ),
                        // appController.postModels.isEmpty
                        //     ? const SizedBox()
                        //     : ListView.builder(padding: const EdgeInsets.only(top: 180, left: 32),
                        //         physics: const ScrollPhysics(),
                        //         shrinkWrap: true,
                        //         itemCount: appController.postJobModels.length,
                        //         itemBuilder: (context, index) => WidgetText(
                        //           text: appController.postModels[index].post,
                        //           textStyle: AppConstant()
                        //               .h3Style(color: Colors.white),
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                  onPageChanged: (value) {
                    appController.indexPage.value = value;
                    appController.postModels.clear();
                    AppService().readPost(
                        docIdReferance: appController
                            .docReferances[appController.indexPage.value]);
                  },
                );
        });
      }),
      bottomSheet: Container(
        width: Get.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: Get.width * 0.8,
              child: WidgetForm(hint: 'ส่งข้อความ :',
                changeFunc: (p0) {},
                marginTop: 0,
                fillColor: Colors.white,
                textEditingController: textEditingController,
              ),
            ),
            WidgetIconButton(
              iconData: Icons.send,
              iconColor: Colors.amber,
              pressFunc: () async {
                if (textEditingController.text.isNotEmpty) {
                  print(
                      'post ---> ${textEditingController.text}, docReferance ----> ${appController.docReferances[appController.indexPage.value]}');

                  PostModel postModel = PostModel(
                    post: textEditingController.text,
                    timestamp: Timestamp.fromDate(DateTime.now()),
                    mapPost: appController.userModelLogins.last.toMap(),
                  );

                  print('postModel ----> ${postModel.toMap()}');

                  FirebaseFirestore.instance
                      .collection('referance')
                      .doc(appController
                          .docReferances[appController.indexPage.value])
                      .collection('post')
                      .doc()
                      .set(postModel.toMap())
                      .then((value) {
                    print('### insert post Success');
                    textEditingController.text = '';
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
