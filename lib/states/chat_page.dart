import 'package:flutter/material.dart';

import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.userModelTechnic,
  }) : super(key: key);

  final UserModel userModelTechnic;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserModel? userModelTechnic;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userModelTechnic = widget.userModelTechnic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: AppService().cutWord(word: userModelTechnic!.name, length: 20),
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SizedBox(
          width: boxConstraints.maxWidth,
          height: boxConstraints.maxHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
            child: Stack(
              children: [
                contentForm(boxConstraints: boxConstraints),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget contentForm({required BoxConstraints boxConstraints}) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WidgetForm(
              marginTop: 0,
              hint: 'ข้อความ',
              changeFunc: (p0) {},
              textEditingController: textEditingController,
            ),
            WidgetButtom(
              label: 'ส่งข้อความ',
              pressFunc: () {
                if (textEditingController.text.isEmpty) {
                  AppDialog(context: context).normalDialog(
                      title: 'ยังไม่มีข้อความ', detail: 'กรุณากรอกข้อความด้วย');
                } else {
                  
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
