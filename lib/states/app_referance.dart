import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/referance_modal.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';

class AddReferance extends StatefulWidget {
  const AddReferance({Key? key}) : super(key: key);

  @override
  State<AddReferance> createState() => _AddReferanceState();
}

class _AddReferanceState extends State<AddReferance> {
  String showDate = 'DD/MM/YYYY';
  AppController controller = Get.put(AppController());

  String? name, detail;
  Timestamp? timestamp;

  @override
  void initState() {
    super.initState();
    if (controller.files.isNotEmpty) {
      controller.files.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'Add Referance',
          textStyle: AppConstant().h2Style(),
        ),
        actions: [
          WidgetIconButton(
            iconData: Icons.save,
            pressFunc: () {
              processSave();
            },
            iconColor: Theme.of(context).primaryColor,
          )
        ],
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('##8dec files--> ${appController.files}');
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: ListView(
                children: [
                  const WidgetShoehead(head: 'รูปภาพผลงาน'),
                  imageBuilding(appController: appController),
                  const WidgetShoehead(head: 'ข้อมูลทั่วไป :'),
                  nameForm(),
                  detailForm(),
                  const WidgetShoehead(head: 'วันที่งานสำเร็จ'),
                  showDateJob(),
                  bottonSave(),
                ],
              ),
            );
          }),
    );
  }

  Row bottonSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetButtom(
          label: 'save Referance',
          pressFunc: () {
            processSave();
          },
          width: 250,
        ),
      ],
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
                textStyle: AppConstant().h3Style(fontWeight: FontWeight.bold),
              ),
              WidgetIconButton(
                iconData: Icons.calculate,
                pressFunc: () async {
                  DateTime dateTime = DateTime.now();

                  await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(dateTime.year - 3),
                    lastDate: dateTime,
                  ).then((value) {
                    DateTime? chooseDateTime = value;
                    if (chooseDateTime != null) {
                      timestamp = Timestamp.fromDate(chooseDateTime);

                      showDate = AppService()
                          .dateTimeToString(dateTime: chooseDateTime);
                      setState(() {});
                    }
                  });
                },
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
          changeFunc: (p0) {
            detail = p0.trim();
          },
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
          changeFunc: (p0) {
            name = p0.trim();
          },
        ),
      ],
    );
  }

  Row imageBuilding({required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: appController.files.isNotEmpty
                  ? SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.file(
                        appController.files[0],
                        fit: BoxFit.cover,
                      ),
                    )
                  : const WidgetImage(
                      path: 'images/build.png',
                      size: 250,
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: WidgetIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () async {
                  if (appController.files.isNotEmpty) {
                    appController.files.clear();
                  }
                  await AppService()
                      .processTakePhoto(source: ImageSource.camera)
                      .then((value) {
                    appController.files.add(value!);
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: WidgetIconButton(
                iconData: Icons.add_photo_alternate,
                pressFunc: () async {
                  if (appController.files.isNotEmpty) {
                    appController.files.clear();
                  }
                  await AppService()
                      .processTakePhoto(source: ImageSource.gallery)
                      .then((value) {
                    appController.files.add(value!);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> processSave() async {
    if (controller.files.isEmpty) {
      AppDialog(context: context)
          .normalDialog(title: 'No Image', detail: 'กรุณาใส่ภาพผลงาน');
    } else if ((name?.isEmpty ?? true) || (detail?.isEmpty ?? true)) {
      AppDialog(context: context).normalDialog(
          title: 'ข้อมูลไม่ครบ', detail: 'กรุณากรอกข้อมูลทั่วไปให้ครบ');
    } else if (timestamp == null) {
      AppDialog(context: context).normalDialog(
          title: 'วันที่งานสำเร็จ', detail: 'กรุณาเลือกวันที่งานสำเร็จ');
    } else {
      String path =
          'referance/${controller.uidLogins[0]}${Random().nextInt(1000000)}.jpg';
      print('path --> $path');

      String? urlImage = await AppService().processUploadImage(path: path);
      print('urlImage --> $urlImage');

      ReferanceModel referanceModel = ReferanceModel(
          urlJob: urlImage!,
          nameJob: name!,
          detail: detail!,
          uidTechnic: controller.uidLogins[0],
          timestampJob: timestamp!,
          timestampUpdate: Timestamp.fromDate(DateTime.now()));

      await FirebaseFirestore.instance
          .collection('referance')
          .doc()
          .set(referanceModel.toMap())
          .then((value) {
        Get.back();
      });
    }
  }
}
