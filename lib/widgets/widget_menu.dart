import 'package:flutter/material.dart';

import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({
    Key? key,
    required this.leadWidget,
    required this.title,
    this.tapFunc,
  }) : super(key: key);

  final Widget leadWidget;
  final String title;
  final Function()? tapFunc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tapFunc,
      leading: leadWidget,
      title: WidgetText(
        text: title,
        textStyle: AppConstant().h2Style(),
      ),
    );
  }
}
