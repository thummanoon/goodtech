import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/message_model.dart';

import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_calculate_distance.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ChatPaeTechnic extends StatefulWidget {
  const ChatPaeTechnic({
    Key? key,
    required this.docIdChat,
    required this.nameUser,
  }) : super(key: key);

  final String docIdChat;
  final String nameUser;

  @override
  State<ChatPaeTechnic> createState() => _ChatPaeTechnicState();
}

class _ChatPaeTechnicState extends State<ChatPaeTechnic> {
  AppController controller = Get.put(AppController());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.docIdChats.add(widget.docIdChat);
    controller.readMessageModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: widget.nameUser,
          textStyle: AppConstant().h2Style(),
        ),
        actions: [WidgetCalcualteDistance()],
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##7jan docIdChat --> ${appController.docIdChats}');
              print(
                  '##7jan messageModels --> ${appController.messageModels.length}');
              return appController.messageModels.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight,
                      child: GestureDetector(onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SizedBox(
                              height: boxConstraints.maxHeight - 60,
                              child: ListMessageChat(appController),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                width: boxConstraints.maxWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    WidgetForm(width: 240,
                                      textEditingController:
                                          textEditingController,
                                      hint: 'ข้อความ',
                                      marginTop: 0,
                                      changeFunc: (p0) {},
                                    ),
                                    WidgetButtom(
                                      label: 'ส่งข้อความ',
                                      pressFunc: () {
                                        print(
                                            '##7jan text --> ${textEditingController.text}');
                        
                                        if (textEditingController.text.isEmpty) {
                                          AppDialog(context: context)
                                              .normalDialog(
                                                  title: 'ไม่มีข้อความ',
                                                  detail: 'กรุณากรอกข้อความด้วย');
                                        } else {
                                          MessageModel messageModel =
                                              MessageModel(
                                                  message:
                                                      textEditingController.text,
                                                  uidPost: appController
                                                      .uidLogins.last,
                                                  timestamp: Timestamp.fromDate(
                                                      DateTime.now()));
                        
                                          AppService()
                                              .insertMessage(
                                                  messageModel: messageModel)
                                              .then((value) {
                                            textEditingController.text = '';
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            });
      }),
    );
  }

  ListView ListMessageChat(AppController appController) {
    return ListView.builder(
      itemCount: appController.messageModels.length,
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: appController.uidLogins.last ==
                appController.messageModels[index].uidPost
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: AppConstant().chatLiftBox(context: context),
            child: Column(
              children: [
                WidgetText(text: appController.messageModels[index].message),
                WidgetText(
                  text: AppService().dateTimeToString(
                      dateTime:
                          appController.messageModels[index].timestamp.toDate(),
                      format: 'dd/MM/yy HH:mm'),
                  textStyle: AppConstant()
                      .h3Style(size: 10, color: AppConstant.chatColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
