import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';

import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetFalsePage extends StatelessWidget {
  const WidgetFalsePage({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WidgetImage(
            path: 'images/technic2.png',
            size: 200,
          ),
          WidgetText(
            text: label,
            textStyle: AppConstant().h1Style(),
          )
        ],
      ),
    );
  }
}
