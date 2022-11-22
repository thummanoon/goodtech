import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetTextButton extends StatelessWidget {
  const WidgetTextButton({
    Key? key,
    required this.label,
    required this.pressFunc,
  }) : super(key: key);

  final String label;
  final Function() pressFunc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressFunc,
        child: WidgetText(
          text: label,
          textStyle: AppConstant().h3Style(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
