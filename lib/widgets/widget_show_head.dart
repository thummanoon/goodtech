import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetShoehead extends StatelessWidget {
  const WidgetShoehead({
    Key? key,
    required this.head,
  }) : super(key: key);

  final String head;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: WidgetText(
        text: head,
        textStyle: AppConstant().h2Style(),
      ),
    );
  }
}
