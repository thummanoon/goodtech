import 'package:flutter/material.dart';

import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetButtom extends StatelessWidget {
  const WidgetButtom({
    Key? key,
    required this.label,
    required this.pressFunc,
    this.width,
  }) : super(key: key);

  final String label;
  final Function() pressFunc;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: pressFunc,
          child: WidgetText(
            text: label,
            textStyle: AppConstant().h3Style(color: AppConstant.bgColor),
          )),
    );
  }
}
