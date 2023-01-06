import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/payment_page.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';

class MessageTechnic extends StatefulWidget {
  const MessageTechnic({Key? key}) : super(key: key);

  @override
  State<MessageTechnic> createState() => _MessageTechnicState();
}

class _MessageTechnicState extends State<MessageTechnic> {
  AppController controller = Get.put(AppController());

  var nameUsers = <String>[];

  @override
  void initState() {
    super.initState();
    controller.readDocIdChatUserTechnics(uid: controller.uidLogins.last);
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##3jan lastMessage ==> ${appController.lastMessages}');
          return (appController.nameUserOrTechnics.isEmpty) ||
                  (appController.lastMessages.isEmpty)
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.chatModelUserTechnic.length,
                  itemBuilder: (context, index) => WidgetMenu(
                    leadWidget: Icon(Icons.message),
                    title: appController.nameUserOrTechnics[index],
                    subTitle: WidgetText(text: appController.lastMessages.last),
                    tapFunc: () {
                      var docIdChats =
                          appController.userModelLogins.last.docIdChats;
                      print('##6jan docIdChats --> $docIdChats');

                      var money = appController.userModelLogins.last.money;

                      if (money == 0.0) {
                        dialogRequire(context);
                      } else if (docIdChats!.isEmpty) {
                        // ยังไม่เคยคุยกับใครเลย
                        AppDialog(context: context).normalDialog(
                            title: 'ระบบทำการตัดเงิน',
                            detail:
                                'ยอดเงินที่คุณมี $money บาท ในการคุยกับลูกค้า ระบบจะทำการตัดเงิน 32.10 บาท ต่อการรับงาน 1 ครั้ง',
                            firstBotton: WidgetTextButton(
                              label: 'ยินดี',
                              pressFunc: () {
                                AppService()
                                    .processPayMoneyForChat(
                                        docIdChat: appController
                                            .docIdChatUserTechnics[index])
                                    .then((value) {
                                  Get.back();
                                });
                              },
                            ));
                      } else {
                        // check ว่า  user เคยคุยด้วยไหม
                      }
                    },
                  ),
                );
        });
  }

  void dialogRequire(BuildContext context) {
    AppDialog(context: context).normalDialog(
      title: 'ยังไม่มีสิทธิ์ Chat',
      detail: 'กรุณาเปิดสิทธิ์เข้าใช้งาน',
      firstBotton: WidgetTextButton(
        label: 'เปิดสิทธิ์ใช้งาน',
        pressFunc: () {
          Get.back();
          Get.to(const PaymentPage());
        },
      ),
    );
  }
}
