import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
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

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    print('userModelLogins --> ${controller.userModelLogins}');
    await controller.findUserModelLogin().then((value) =>
        print('userModelLogins  last --> ${controller.userModelLogins}'));

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        statusLogin = false;
      } else {
        statusLogin = true;
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
            appBar: AppBar(
              title: WidgetText(
                text: 'Main Home',
                textStyle: AppConstant().h2Style(),
              ),
            ),
            drawer: load
                ? const WidgetProgress()
                : Drawer(
                    child: Column(
                      children: [
                        headDrawer(appController),
                        WidgetMenu(
                          leadWidget: const WidgetImage(
                            path: 'images/home.png',
                          ),
                          title: 'หน้าหลัก',
                          tapFunc: () {
                            Get.back();
                          },
                        ),
                        statusLogin!
                            ? appController.userModelLogins[0].typeUser ==
                                    AppConstant.typeUsers[1]
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/messag.png',
                                        ),
                                        title: 'ข่าวสาร',
                                        tapFunc: () {
                                          Get.back();
                                        },
                                      ),
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/profine.png',
                                        ),
                                        title: 'profine',
                                        tapFunc: () {
                                          Get.back();
                                        },
                                      ),
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/referent.png',
                                        ),
                                        title: 'referent',
                                        tapFunc: () {
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
                                    tapFunc: () {
                                      Get.back();
                                    },
                                  )
                            : const SizedBox(),
                        const Spacer(),
                        Divider(
                          color: AppConstant.dark,
                        ),
                        statusLogin! ? menuSignOut() : menuAuthen(),
                      ],
                    ),
                  ),
          );
        });
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
