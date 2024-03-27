import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/post_model.dart';
import 'package:goodtech/states/authen.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_show_profile.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';
import 'package:goodtech/widgets/widget_text_expan.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  AppController appController = Get.put(AppController());
  PageController? pageController;
  TextEditingController textEditingController = TextEditingController();

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      streamSubscription;

  @override
  void initState() {
    super.initState();
    AppService().findUserModelLogin().then((value) {
      print(
          '##28feb userModel at List page ---> ${appController.userModelLogins.length}');
    });

    AppService().readFirstReferance().then((value) {
      pageController =
          PageController(initialPage: appController.indexPage.value);

      realTimeReadPost(
          docIdReferance:
              appController.docReferances[appController.indexPage.value]);
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  Future<void> realTimeReadPost({required String docIdReferance}) async {
    print('##29feb docIdReferanct--> $docIdReferance');

    streamSubscription = FirebaseFirestore.instance
        .collection('referance')
        .doc(docIdReferance)
        .collection('post')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
      if (appController.postModels.isNotEmpty) {
        appController.postModels.clear();
      }

      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          PostModel model = PostModel.fromMap(element.data());
          appController.postModels.add(model);
        }
      }

      print(
          '##29feb ขนาดของ postModels --> ${appController.postModels.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
          return Obx(() {
            return appController.referanceModels.isEmpty
                ? const SizedBox()
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: appController.referanceModels.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ชื่อ
                                        SizedBox(
                                          width: boxConstraints.maxWidth * 0.55,
                                          child: WidgetText(
                                            text: appController
                                                .referanceModels[index]
                                                .nameTechnic,
                                            textStyle: AppConstant()
                                                .h2Style(color: Colors.white),
                                          ),
                                        ),
                                        // ชื่องาน
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
                                        // รายละเอียด
                                        SizedBox(
                                          width: boxConstraints.maxWidth * 0.55,
                                          child: WidgetTextExpanable(
                                            data: appController
                                                .referanceModels[index].detail,
                                            textStyle: AppConstant()
                                                .h3Style(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              WidgetIconButton(
                                iconData: Icons.home,
                                pressFunc: () {
                                  Get.offAllNamed('/navigator');
                                },
                                size: 48,
                                iconColor: Colors.yellow,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                WidgetImageInternet(
                                  urlPath: appController
                                      .referanceModels[index].urlJob,
                                ),
                                Obx(() {
                                  return Positioned(
                                    left: 16,
                                    top: Get.height * 0.5,
                                    child: appController.postModels.isEmpty
                                        ? const SizedBox()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            width: Get.width * 0.6,
                                            height: Get.height * 0.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black38),
                                            child: ListView.builder(
                                              reverse: true,
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemCount: appController
                                                  .postModels.length,
                                              itemBuilder: (context, index) =>
                                                  Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  WidgetText(
                                                    text: appController
                                                        .postModels[index]
                                                        .mapPost['name'],
                                                    textStyle: AppConstant()
                                                        .h3Style(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  WidgetText(
                                                    text: appController
                                                        .postModels[index].post,
                                                    textStyle: AppConstant()
                                                        .h3Style(
                                                            color:
                                                                Colors.amber),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  );
                                }),
                                Positioned(
                                  right: 16,
                                  bottom: Get.height * 0.3,
                                  child: Column(mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WidgetIconButton(
                                        iconColor: Colors.pink,
                                        iconData: Icons.favorite,
                                        pressFunc: () {
                                          print('You tap');
                                        },
                                      ),
                                      WidgetText(text: '123', textStyle: AppConstant().h3Style(color: Colors.white, fontWeight: FontWeight.w700),)
                                    ],
                                  ),
                                )
                              ],
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
                      streamSubscription.cancel();

                      appController.indexPage.value = value;

                      realTimeReadPost(
                          docIdReferance: appController
                              .docReferances[appController.indexPage.value]);
                    },
                  );
          });
        }),
      ),
      bottomSheet: Container(
        width: Get.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: Get.width * 0.8,
              child: WidgetForm(
                hint: 'ส่งข้อความ :',
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
                if (appController.userModelLogins.isEmpty) {
                  // ไม่ได้ Login
                  AppDialog(context: context).normalDialog(
                    title: 'ยังไม่ได้สมัครสมาชิก',
                    detail: 'กรุณาสมัครสมาชิกก่อน',
                    firstBotton: WidgetTextButton(
                      label: 'Login',
                      pressFunc: () {
                        Get.back();
                        Get.to(const Authen(
                          fromListPsge: true,
                        ))?.then((value) {
                          AppService().findUserModelLogin();
                        });
                      },
                    ),
                    secondBotton: WidgetTextButton(
                      label: 'สมัครสมาชิก',
                      pressFunc: () {
                        Get.back();
                        Get.toNamed(AppConstant.pageAccountUser);
                      },
                    ),
                  );
                } else {
                  // Logined

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

                      AppService().processSendNotiByUid(
                          title: 'มีข้อความ',
                          body: 'ดูข้อความ',
                          uid: appController
                              .referanceModels[appController.indexPage.value]
                              .uidTechnic);
                    });
                  } //if
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
