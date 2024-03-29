import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/edit_profile_technic.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_google_map.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_show_profile.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ProfileTechnic extends StatefulWidget {
  const ProfileTechnic({Key? key}) : super(key: key);

  @override
  State<ProfileTechnic> createState() => _ProfileTechnicState();
}

class _ProfileTechnicState extends State<ProfileTechnic> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModel ==> ${appController.userModels}');
          return appController.userModels.isEmpty
              ? const WidgetProgress()
              : ListView(
                  children: [
                    const WidgetShoehead(head: 'กระเป๋าเงิน :'),
                    showTitle(
                        head: 'ยอดเงินคงเหลือ',
                        flex: 4,
                        value: appController.userModels.last.money.toString()),
                    imageProfile(appController),

                       editButton(appController),


                    const WidgetShoehead(head: 'ข้อมูลทั่วไป :'),
                    showTitle(
                        head: 'ชื่อ :',
                        value: appController.userModels[0].name),
                    showTitle(
                        head: 'ที่อยู่ :',
                        value: appController.userModels[0].address),
                    showTitle(
                        head: 'เบอร์โทร :',
                        value: appController.userModels[0].phone),
                    const WidgetShoehead(head: 'Skill Technic :'),
                    listskill(appController),
                    const WidgetShoehead(head: 'แผนที่ร้าน :'),
                    showmap(appController),
                    
                  ],
                );
        });
  }

  Row editButton(AppController appController) {
    return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        width: 250,
                        child: WidgetButtom(
                          label: 'แก้ไข Profile',
                          pressFunc: () {
                            Get.to(const EditProfileTechnic())!.then((value) {
                              appController.findUserModel(
                                  uid: appController.uidLogins[0]);
                              appController.readAllTypeUser();
                              appController.findUserModelLogin();
                            });
                          },
                        ),
                      ),
                    ],
                  );
  }

  Row showmap(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: AppConstant().borderCurveBox(),
          width: 250,
          height: 200,
          child: WidgetGoogleMap(
              lat: appController.userModels[0].geoPoint.latitude,
              lng: appController.userModels[0].geoPoint.longitude),
        ),
      ],
    );
  }

  Row listskill(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.userModels[0].skillTechnic!.length,
            itemBuilder: (context, index) => WidgetText(
                text: appController.userModels[0].skillTechnic![index]),
          ),
        ),
      ],
    );
  }

  Padding showTitle({required String head, required String value, int? flex}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: flex ?? 2,
            child: WidgetText(
              text: head,
              textStyle: AppConstant().h2Style(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: WidgetText(
              text: value,
              textStyle:
                  AppConstant().h2Style(fontWeight: FontWeight.w500, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Row imageProfile(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14
          ),
          child: WidgetShowProfile(
            urlImage: appController.userModels[0].urlProfile!.isEmpty
                ? AppConstant.urlFreeProfile
                : appController.userModels[0].urlProfile!,
            radius: 100,
          ),
        ),
      ],
    );
  }
}
