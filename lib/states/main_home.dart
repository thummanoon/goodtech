import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class MainHome extends StatelessWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Main Home',
          textStyle: AppConstant().h2Style(),
        ),
      ),
    );
  }
}
