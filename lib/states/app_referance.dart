import 'package:flutter/material.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_text.dart';

class AddReferance extends StatefulWidget {
  const AddReferance({Key? key}) : super(key: key);

  @override
  State<AddReferance> createState() => _AddReferanceState();
}

class _AddReferanceState extends State<AddReferance> {
  String showDate = 'DD/MM/YYYY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Add Referance',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: ListView(
        children: [
          const WidgetShoehead(head: 'รูปภาพผลงาน'),
          imageBuilding(),
          const WidgetShoehead(head: 'ข้อมูลทั่วไป :'),
          nameForm(),
          detailForm(),
          showDateJob(),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetButtom(
                label: 'save Referance',
                pressFunc: () {},width: 250,
              ),
            ],
          )
        ],
      ),
    );
  }

  Row showDateJob() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetText(
                text: showDate,
                textStyle: AppConstant().h3Style(),
              ),
              WidgetIconButton(
                iconData: Icons.calculate,
                pressFunc: () {},
              )
            ],
          ),
        ),
      ],
    );
  }

  Row detailForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          labelWidget: WidgetText(
              text: 'รายละเอียดผลงาน :', textStyle: AppConstant().h3Style()),
          changeFunc: (p0) {},
        ),
      ],
    );
  }

  Row nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          labelWidget: WidgetText(
              text: 'ชื่อผลงาน :', textStyle: AppConstant().h3Style()),
          changeFunc: (p0) {},
        ),
      ],
    );
  }

  Row imageBuilding() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: WidgetImage(
                path: 'images/build.png',
                size: 250,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: WidgetIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () {},
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: WidgetIconButton(
                iconData: Icons.add_photo_alternate,
                pressFunc: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
