import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/typeteachnic_model.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image.dart';
import 'package:goodtech/widgets/widget_menu.dart';
import 'package:goodtech/widgets/widget_progress.dart';
import 'package:goodtech/widgets/widget_text.dart';
import '../utility/app_service.dart';
import '../widgets/widget_buttom.dart';
import '../widgets/widget_form.dart';
import '../widgets/widget_google_map.dart';

class CreateAccountTeachnic extends StatefulWidget {
  const CreateAccountTeachnic({Key? key}) : super(key: key);

  @override
  State<CreateAccountTeachnic> createState() => _CreateAccountTeachnicState();
}

class _CreateAccountTeachnicState extends State<CreateAccountTeachnic> {
  Position? position;
  var typeTechnicModels = <TypeTeachnicModel>[];
  var chooseTypeTechnics = <bool>[];

  String? name, surName, address, phone, email, password;

  @override
  void initState() {
    super.initState();
    findPosition();
    readAllTypeTechnic();
  }

  Future<void> readAllTypeTechnic() async {
    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TypeTeachnicModel model = TypeTeachnicModel.fromMap(element.data());
        typeTechnicModels.add(model);
        chooseTypeTechnics.add(false);
      }
      setState(() {});
    });
  }

  Future<void> findPosition() async {
    await AppService().processFindPosition(context: context).then((value) {
      position = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
          return Container(
            decoration:
                AppConstant().imageBox(path: 'images/vg2.jpg', opacity: 0.5),
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                WidgetMenu(
                    leadWidget: WidgetIconButton(
                      iconColor: AppConstant.dark,
                      iconData: Icons.arrow_back,
                      pressFunc: () {
                        Get.back();
                      },
                    ),
                    title: AppConstant.typeUserShows[1]),
                Positioned(
                  top: boxConstraints.maxWidth * 0.1,
                  right: boxConstraints.maxWidth * 0.1,
                  child: WidgetImage(
                    size: boxConstraints.maxWidth * 0.2,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 32, top: 32, right: 32),
                    decoration: AppConstant().curveBox(),
                    width: boxConstraints.maxWidth,
                    height: boxConstraints.maxHeight -
                        boxConstraints.maxWidth * 0.4,
                    child: ListView(
                      children: [
                        WidgetText(
                          text: 'ข้อมูลช่าง :',
                          textStyle: AppConstant().h2Style(),
                        ),
                        WidgetForm(
                          labelWidget: WidgetText(text: 'ชื่อ'),
                          changeFunc: (p0) {
                            name = p0.trim();
                          },
                        ),
                        WidgetForm(
                          labelWidget: WidgetText(text: 'นามสกุล'),
                          changeFunc: (p0) {
                            surName = p0.trim();
                          },
                        ),
                        WidgetForm(
                          labelWidget: WidgetText(text: 'ที่อยู่'),
                          changeFunc: (p0) {
                            address = p0.trim();
                          },
                        ),
                        WidgetForm(
                          textInputType: TextInputType.phone,
                          labelWidget: WidgetText(text: 'เบอร์โทรศัพท์'),
                          changeFunc: (p0) {
                            phone = p0.trim();
                          },
                        ),
                        WidgetForm(
                          textInputType: TextInputType.emailAddress,
                          labelWidget: WidgetText(text: 'Email'),
                          changeFunc: (p0) {
                            email = p0.trim();
                          },
                        ),
                        WidgetForm(
                          labelWidget: WidgetText(text: 'Password'),
                          changeFunc: (p0) {
                            password = p0.trim();
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: WidgetText(
                            text: 'ชนิดของช่าง :',
                            textStyle: AppConstant().h2Style(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: AppConstant().borderCurveBox(),
                          width: boxConstraints.maxWidth,
                          child: typeTechnicModels.isEmpty
                              ? const WidgetProgress()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: typeTechnicModels.length,
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: chooseTypeTechnics[index],
                                      onChanged: (value) {
                                        chooseTypeTechnics[index] = value!;
                                        setState(() {});
                                      },
                                      title: WidgetText(
                                          text: typeTechnicModels[index].name),
                                    );
                                  },
                                ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: WidgetText(
                            text: 'พิกัด :',
                            textStyle: AppConstant().h2Style(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: AppConstant().borderCurveBox(),
                          width: boxConstraints.maxWidth * 0.8,
                          height: boxConstraints.maxWidth * 0.6,
                          child: position == null
                              ? const WidgetProgress()
                              : WidgetGoogleMap(
                                  lat: position!.latitude,
                                  lng: position!.longitude),
                        ),
                        WidgetButtom(
                          label: 'ยืนยัน',
                          pressFunc: () {
                            if ((name?.isEmpty ?? true) ||
                                (surName?.isEmpty ?? true) ||
                                (address?.isEmpty ?? true) ||
                                (phone?.isEmpty ?? true) ||
                                (email?.isEmpty ?? true) ||
                                (password?.isEmpty ?? true)) {
                              AppDialog(context: context).normalDialog(
                                  title: 'มีช่องว่าง ?',
                                  detail: 'กรุณากรอกให้ครบทุกช่อง');
                            } else if (AppService().checkChooseTypeTechnic(
                                listChooses: chooseTypeTechnics)) {
                              AppDialog(context: context).normalDialog(
                                  title: 'ยังไม่ได้เลือกชนิดของช่าง',
                                  detail: 'กรุณาเลือกชนิดของช่าง');
                            } else {}
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
