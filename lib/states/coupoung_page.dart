import 'package:flutter/material.dart';
import 'package:goodtech/widgets/widget_text.dart';

class CoupoungPage extends StatelessWidget {
  const CoupoungPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:  AppBar(title: WidgetText(text: 'คูปองของฉัน'),),);
  }
}