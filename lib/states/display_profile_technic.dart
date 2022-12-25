import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/chat_page.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_google_map.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_show_head.dart';
import 'package:goodtech/widgets/widget_show_profile.dart';
import 'package:goodtech/widgets/widget_text.dart';

class DisplayProfileTechnic extends StatefulWidget {
  const DisplayProfileTechnic({
    Key? key,
    required this.userModelTechnic,
  }) : super(key: key);

  final UserModel userModelTechnic;

  @override
  State<DisplayProfileTechnic> createState() => _DisplayProfileTechnicState();
}

class _DisplayProfileTechnicState extends State<DisplayProfileTechnic> {
  UserModel? userModelTechnic;
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    userModelTechnic = widget.userModelTechnic;
    refreshReferanceModel();
  }

  Future<void> refreshReferanceModel() async {
    String emailTechnic = userModelTechnic!.email;
    print('##25dec emailTechnic --> $emailTechnic ');
    var docIdUsers =
        await AppService().findDocIdUserWhereEmail(email: emailTechnic);
    print('##25dec docIdUser --> $docIdUsers');

    controller.readTechReferance(uidTechnic: docIdUsers.last);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                'typeUserLogin ---> ${appController.userModelLogins.last.typeUser}');
            return Scaffold(
              backgroundColor: AppConstant.bgColor,
              appBar: AppBar(
                title: WidgetText(
                  text:
                      'Profile ช่าง ${AppService().cutWord(word: userModelTechnic!.name, length: 10)}',
                  textStyle: AppConstant().h2Style(),
                ),
                actions: [
                  appController.userModelLogins.last.typeUser == 'user'
                      ? WidgetIconButton(
                          iconData: Icons.maps_ugc_outlined,
                          pressFunc: () {
                            Get.to(ChatPage(userModelTechnic: userModelTechnic!,));
                          },
                        )
                      : const SizedBox(),
                ],
              ),
              body: ListView(
                children: [
                  displayimage(),
                  const WidgetShoehead(head: 'ข้อมูลทั่วไป :'),
                  showTitle(head: 'ชื่อ :', value: userModelTechnic!.name),
                  showTitle(
                      head: 'ที่อยู่ :', value: userModelTechnic!.address),
                  appController.userModelLogins.last.typeUser == 'user'
                      ? const SizedBox()
                      : showTitle(
                          head: 'เบอร์โทร :', value: userModelTechnic!.phone),
                  const WidgetShoehead(head: 'ความถนัดของช่าง :'),
                  listskill(),
                  const WidgetShoehead(head: 'แผนที่ร้าน :'),
                  showmap(),
                  const WidgetShoehead(head: 'Referance ที่ผ่านมา :'),
                  appController.referanceModels.isEmpty
                      ? const SizedBox()
                      : listReferance(
                          boxConstraints: boxConstraints,
                          appController: appController),
                ],
              ),
            );
          });
    });
  }

  ListView listReferance(
      {required BoxConstraints boxConstraints,
      required AppController appController}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: appController.referanceModels.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: boxConstraints.maxWidth * 0.4,
                height: boxConstraints.maxWidth * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: WidgetImageInternet(
                      urlPath: appController.referanceModels[index].urlJob),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: boxConstraints.maxWidth * 0.6,
                height: boxConstraints.maxWidth * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(
                        text: AppService().cutWord(
                            word: appController.referanceModels[index].nameJob,
                            length: 25),
                        textStyle:
                            AppConstant().h3Style(fontWeight: FontWeight.bold)),
                    WidgetText(
                        text: AppService().cutWord(
                            word: appController.referanceModels[index].detail,
                            length: 80)),
                    const Spacer(),
                    WidgetText(
                      text: AppService().dateTimeToString(
                        dateTime: appController
                            .referanceModels[index].timestampJob
                            .toDate(),
                      ),
                      textStyle: AppConstant().h3Style(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: AppConstant.dark,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Row showmap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: AppConstant().borderCurveBox(),
          width: 250,
          height: 200,
          child: WidgetGoogleMap(
              lat: userModelTechnic!.geoPoint.latitude,
              lng: userModelTechnic!.geoPoint.longitude),
        ),
      ],
    );
  }

  Row listskill() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: userModelTechnic!.skillTechnic!.length,
            itemBuilder: (context, index) =>
                WidgetText(text: userModelTechnic!.skillTechnic![index]),
          ),
        ),
      ],
    );
  }

  Padding showTitle({required String head, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
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

  Row displayimage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetShowProfile(
            radius: 125,
            urlImage: userModelTechnic!.urlProfile!.isEmpty
                ? AppConstant.urlFreeProfile
                : userModelTechnic!.urlProfile!),
      ],
    );
  }
}
