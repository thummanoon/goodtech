import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_show_profile.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileTechnic extends StatefulWidget {
  const EditProfileTechnic({Key? key}) : super(key: key);

  @override
  State<EditProfileTechnic> createState() => _EditProfileTechnicState();
}

class _EditProfileTechnicState extends State<EditProfileTechnic> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  AppController controller = Get.put(AppController());

  String? chooseSkill;
  @override
  void initState() {
    super.initState();

    nameController.text = controller.userModels[0].name;
    addressController.text = controller.userModels[0].address;
    phoneController.text = controller.userModels[0].phone;

    for (var element in controller.userModels[0].skillTechnic!) {
      controller.typeUsers.remove(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('typeUser ---> ${appController.typeUsers}');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: WidgetText(
                text: 'แก้ไขโปรไฟล์',
                textStyle: AppConstant().h2Style(),
              ),
              actions: [
                WidgetIconButton(
                  iconData: Icons.save,
                  pressFunc: () {
                    saveEditProfile();
                  },
                  iconColor: Theme.of(context).primaryColor,
                )
              ],
            ),
            body: ListView(
              children: [
                imageprofile(appController),
                const WidgetShoehead(head: 'ข้อมูลทั่วไป :'),
                generalform(),
                const WidgetShoehead(head: 'สกิลช่าง :'),
                listSkillDelete(appController),
                dropdownAddSkill(appController),
                const WidgetShoehead(head: 'แผนที่ร้าน :'),
                bottomsave(),
              ],
            ),
          );
        });
  }

  Row bottomsave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          child: WidgetButtom(
            label: 'save Profile',
            pressFunc: () {
              saveEditProfile();
            },
          ),
        ),
      ],
    );
  }

  Row dropdownAddSkill(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: DropdownButton(
            isExpanded: true,
            hint: WidgetText(
              text: 'เพิ่มสกิลช่าง',
              textStyle: AppConstant().h3Style(),
            ),
            value: chooseSkill,
            items: appController.typeUsers
                .map(
                  (element) => DropdownMenuItem(
                    child: WidgetText(text: element),
                    value: element,
                  ),
                )
                .toList(),
            onChanged: (value) {
              chooseSkill = value;
              setState(() {});
            },
          ),
        ),
        WidgetIconButton(
          iconData: Icons.save,
          iconColor: Colors.green,
          pressFunc: () {},
        )
      ],
    );
  }

  Row listSkillDelete(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.userModels[0].skillTechnic!.length,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetText(
                    text: appController.userModels[0].skillTechnic![index]),
                WidgetIconButton(
                  iconData: Icons.delete_forever_outlined,
                  iconColor: Colors.red,
                  pressFunc: () {},
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container generalform() {
    return Container(
      width: 250,
      child: Column(
        children: [
          WidgetForm(
            labelWidget: WidgetText(
              text: 'ชื่อ :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: nameController,
            changeFunc: (p0) {},
          ),
          WidgetForm(
            labelWidget: WidgetText(
              text: 'ที่อยู่ :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: addressController,
            changeFunc: (p0) {},
          ),
          WidgetForm(
            labelWidget: WidgetText(
              text: 'เบอร์โทร :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: phoneController,
            changeFunc: (p0) {},
          ),
        ],
      ),
    );
  }

  Widget imageprofile(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 220,
          child: Stack(
            children: [
              appController.files.isEmpty
                  ? WidgetShowProfile(
                      radius: 100,
                      urlImage: appController.userModels[0].urlProfile!.isEmpty
                          ? AppConstant.urlFreeProfile
                          : appController.userModels[0].urlProfile!)
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(appController.files[0]),
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
                    File? file = await AppService()
                        .processTakePhoto(source: ImageSource.camera);
                    appController.files.add(file!);
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
                    File? file = await AppService()
                        .processTakePhoto(source: ImageSource.gallery);
                    appController.files.add(file!);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> saveEditProfile() async {
    if (controller.files.isNotEmpty) {
      //มีการเปลี่ยนภาพ

      String nameFile =
          '${controller.uidLogins[0]}${Random().nextInt(1000000)}.jpg';
      

      String? urlImage = await AppService().processUploadImage(path: 'profile/$nameFile');
      print('Have Photo $urlImage');
    } else {
      //ไม่มีการเปลี่ยนภาพ
      print('No Photo');
    }
  }
}