import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_text.dart';

class CreateAccountTeachnic extends StatelessWidget {
  const CreateAccountTeachnic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: AppConstant.typeUserShows[1],
          textStyle: AppConstant().h2Style(),
        ),
      ),
    );
  }
}
