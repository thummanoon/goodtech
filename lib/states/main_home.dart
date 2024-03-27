import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/bodys/category_technic.dart';
import 'package:goodtech/bodys/main_center.dart';
import 'package:goodtech/bodys/message_technic.dart';
import 'package:goodtech/bodys/message_user.dart';
import 'package:goodtech/bodys/profile_technic.dart';
import 'package:goodtech/bodys/referance_technic.dart';
import 'package:goodtech/states/list_page.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool? statusLogin; //true =>Login, false => LogOut
  bool load = true;

  AppController controller = Get.put(AppController());
  var bodys = <Widget>[
    const MainCenter(),
    const MessageTechnic(),
    const ProfileTechnic(),
    const ReferanceTechnic(),
    const MessageUser(),
    const CategoryTechnic(),
  ];

  var titles = <String>[
    'หน้าแรก',
    'ข่าวสาร',
    'profile',
    'referance',
    'ข่าวสาร',
    'กลุ่มของช่างและบริการ',
  ];

  @override
  void initState() {
    super.initState();
    checkLogin();
    controller.readAllTypeUser();
  }

  Future<void> checkLogin() async {
    print('userModelLogins --> ${controller.userModelLogins}');
    await controller.findUserModelLogin().then((value) =>
        print('userModelLogins  last --> ${controller.userModelLogins}'));

    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event == null) {
        statusLogin = false;
      } else {
        statusLogin = true;
        controller.findUserModel(uid: event.uid);

        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        String? token = await firebaseMessaging.getToken();
        print('##25dec token ---> $token');

        AppService().processUploadToken(token: token!);

        AppService().monitorNoti(context: context);
      }
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('current userModel ---> ${appController.userModelLogins}');
          return Scaffold(
            backgroundColor: AppConstant.bgColor,
            appBar: AppBar(
              title: WidgetText(
                text: titles[appController.indexBody.value],
                textStyle: AppConstant().h2Style(),
              ),
              actions: [
                WidgetIconButton(
                  iconData: Icons.fact_check,
                  pressFunc: () {
                    Get.offAll(const ListPage());
                  },
                  tooltip: 'ผลงานช่าง',
                )
              ],
            ),
            drawer: load ? const WidgetProgress() : mainDrawer(appController),
            body: bodys[appController.indexBody.value],
          );
        });
  }

  Drawer mainDrawer(AppController appController) {
    return Drawer(
      child: ListView(
        children: [
          headDrawer(appController),
          WidgetMenu(
            leadWidget: const WidgetImage(
              path: 'images/home.png',
              size: 35,
            ),
            title: 'หน้าแรก',
            tapFunc: () {
              appController.indexBody.value = 0;
              Get.back();
            },
          ),
          statusLogin!
              ? appController.userModelLogins.isEmpty ? const SizedBox() : appController.userModelLogins[0].typeUser ==
                      AppConstant.typeUsers[1]
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetMenu(
                          leadWidget: const WidgetImage(
                            path: 'images/messag.png',
                            size: 35,
                          ),
                          title: 'ข่าวสาร',
                          subTitle: const WidgetText(text: 'ข่าวสารสำหรับช่าง'),
                          tapFunc: () {
                            appController.indexBody.value = 1;
                            Get.back();
                          },
                        ),
                        WidgetMenu(
                          leadWidget: const WidgetImage(
                            path: 'images/profine.png',
                            size: 35,
                          ),
                          title: 'ข้อมูลช่างและบริการ',
                          tapFunc: () {
                            appController.indexBody.value = 2;
                            Get.back();
                          },
                        ),
                        WidgetMenu(
                          leadWidget: const WidgetImage(
                            path: 'images/referent.png',
                            size: 35,
                          ),
                          title: 'ผลงานที่ผ่านมา',
                          tapFunc: () {
                            appController.indexBody.value = 3;
                            Get.back();
                          },
                        ),
                      ],
                    )
                  : WidgetMenu(
                      leadWidget: const WidgetImage(
                        path: 'images/messag.png',
                      ),
                      title: 'ข่าวสาร',
                      subTitle: const WidgetText(text: 'ข่าวสารสำหรับสมาชิก'),
                      tapFunc: () {
                        appController.indexBody.value = 4;
                        Get.back();
                      },
                    )
              : const SizedBox(),
          WidgetMenu(
            leadWidget: const WidgetImage(
              path: 'images/category.png',
            ),
            title: 'กลุ่มของช่างและบริการ',
            tapFunc: () {
              appController.indexBody.value = 5;
              Get.back();
            },
          ),
          // const Spacer(),
          Divider(
            color: AppConstant.dark,
          ),
          statusLogin! ? menuSignOut() : menuAuthen(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader headDrawer(AppController appController) {
    return UserAccountsDrawerHeader(
      decoration: AppConstant().imageBox(path: 'images/bg1.jpg', opacity: 0.5),
      accountName: appController.userModelLogins.isEmpty
          ? null
          : WidgetText(
              text: appController.userModelLogins[0].name,
              textStyle: AppConstant().h2Style(),
            ),
      currentAccountPicture: const WidgetImage(),
      accountEmail: appController.userModelLogins.isEmpty
          ? null
          : WidgetText(
              text: 'Type : ${appController.userModelLogins[0].typeUser}',
              textStyle: AppConstant().h3Style(fontWeight: FontWeight.w500),
            ),
    );
  }

  WidgetMenu menuSignOut() {
    return WidgetMenu(
        tapFunc: () {
          AppDialog(context: context).normalDialog(
              title: 'ยืนยัน SignOut',
              detail: 'กรุณายืนยันการ SignOut',
              firstBotton: WidgetTextButton(
                label: 'ยืนยัน SignOut',
                pressFunc: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    checkLogin();
                    Get.back();
                    Get.back();
                  });
                },
              ),
              secondBotton: WidgetTextButton(
                label: 'Cancel',
                pressFunc: () {
                  Get.back();
                  Get.back();
                },
              ));
        },
        leadWidget: const Icon(
          Icons.exit_to_app,
          size: 36,
        ),
        title: 'Sign Out');
  }

  WidgetMenu menuAuthen() {
    return WidgetMenu(
        tapFunc: () {
          Get.back();
          Get.toNamed(AppConstant.pageAuthen)?.then((value) {
            checkLogin();
          });
        },
        leadWidget: const Icon(
          Icons.login,
          size: 36,
        ),
        title: 'ลงชื่อเข้าใช้งาน');
  }
}
