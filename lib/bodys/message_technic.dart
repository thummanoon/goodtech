import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_text.dart';

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
          print(
              '##3jan readDocIdChatUserTechnic ==> ${appController.docIdChatUserTechnics}');
          return appController.nameUserOrTechnics.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.chatModelUserTechnic.length,
                  itemBuilder: (context, index) => WidgetMenu(
                      leadWidget: Icon(Icons.message),
                      title: appController.nameUserOrTechnics[index], subTitle: WidgetText(text: 'Last Message'),),
                );
        });
  }
}
