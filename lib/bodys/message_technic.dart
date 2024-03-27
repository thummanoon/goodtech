import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/chat_page_technic.dart';
import 'package:goodtech/states/payment_page.dart';
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
                    leadWidget: const Icon(Icons.message),
                    title: appController.nameUserOrTechnics[index],
                    subTitle: WidgetText(text: appController.lastMessages.last),
                    tapFunc: () {
                      //  uid ของเพื่อน
                      String uidFriend = appController
                          .chatModelUserTechnic.last.friends[index];

                      //  uid ของเราเอง
                      var user = FirebaseAuth.instance.currentUser;
                      String uidUserLogin = user!.uid;

                      print(
                          '## uidFriend = $uidFriend, uidUserLogin = $uidUserLogin');

                      AppService()
                          .processFindDocIdChat(
                              uidUserLogin: uidUserLogin, uidFriend: uidFriend)
                          .then((value) {
                        Get.to(ChatPaeTechnic(
                          docIdChat: appController.docIdChatMessages.last,
                          nameUser: appController.nameUserOrTechnics[index],
                        ));
                      });

                      // นี่คือโค๊ดเก่า
                      // var docIdChats =
                      //     appController.userModelLogins.last.docIdChats;
                      // print('##6jan docIdChats --> $docIdChats');

                      // String money = appController.userModelLogins.last.money!;

                      // if (money.isEmpty) {
                      //   dialogRequire(context);
                      // } else if (double.parse(money) < 32.10) {
                      //   dialogRequire(context,
                      //       title: 'จำนวนเงินในกระเป๋าเงินไม่พอ',
                      //       detail: 'กรุณาเติมเงิน',
                      //       label: 'เติมเงิน');
                      // } else if (docIdChats!.isEmpty) {
                      //   // ยังไม่เคยคุยกับใครเลย
                      //   dialogPayMoney(context, money, appController, index);
                      // } else {
                      //   // check ว่า  user เคยคุยด้วยไหม ?

                      //   String docIdChat =
                      //       appController.docIdChatUserTechnics.last;

                      //   if (appController.userModelLogins.last.docIdChats!
                      //       .contains(docIdChat)) {
                      //     print(
                      //         '##6jan Check ว่า user เคยคุยด้วยไหม เคยคุยกันแล้ว ');

                      //     Get.to(ChatPaeTechnic(
                      //       docIdChat: docIdChat,
                      //       nameUser: appController.nameUserOrTechnics[index],
                      //     ));
                      //   } else {
                      //     print(
                      //         '##6jan Check ว่า user เคยคุยด้วยไหม  ไม่เคยคุยกัน ');
                      //     dialogPayMoney(context, money, appController, index);
                      //   }
                      // }
                    },
                  ),
                );
        });
  }

  void dialogPayMoney(BuildContext context, String? money,
      AppController appController, int index) {
    var user = FirebaseAuth.instance.currentUser;
    AppDialog(context: context).normalDialog(
        title: 'ระบบทำการตัดเงิน',
        detail:
            'ยอดเงินที่คุณมี $money บาท ในการคุยกับลูกค้า ระบบจะทำการตัดเงิน 32.10 บาท ต่อการรับงาน 1 ครั้ง',
        firstBotton: WidgetTextButton(
          label: 'ยินดี',
          pressFunc: () {
            AppService()
                .processPayMoneyForChat(
                    docIdChat: appController.docIdChatUserTechnics[index])
                .then((value) {
              Get.back();
              appController.findUserModel(uid: user!.uid);
            });
          },
        ));
  }
  //อัพเดต

  void dialogRequire(BuildContext context,
      {String? title, String? detail, String? label}) {
    AppDialog(context: context).normalDialog(
      title: title ?? 'ยังไม่มีสิทธิ์ Chat',
      detail: detail ?? 'กรุณาเปิดสิทธิ์เข้าใช้งาน',
      firstBotton: WidgetTextButton(
        label: label ?? 'เปิดสิทธิ์ใช้งาน',
        pressFunc: () {
          Get.back();
          Get.to(const PaymentPage());
        },
      ),
    );
  }
}
