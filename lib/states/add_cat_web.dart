import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class AddCatWeb extends StatelessWidget {
  const AddCatWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Add New Catigory',
          textStyle: AppConstant().h2Style(),
        ),
      ),
    );
  }
}
