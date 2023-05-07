import 'package:flutter/material.dart';
import 'package:goodtech/widgets/widget_text.dart';

class NotiPage extends StatelessWidget {
  const NotiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: WidgetText(text: 'แจ้งเตือน'),),);
  }
}