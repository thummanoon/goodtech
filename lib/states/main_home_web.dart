import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/states/manage_cat_web.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_text.dart';

class MainHomeWeb extends StatefulWidget {
  const MainHomeWeb({Key? key}) : super(key: key);

  @override
  State<MainHomeWeb> createState() => _MainHomeWebState();
}

class _MainHomeWebState extends State<MainHomeWeb> {
  @override
  void initState() {
    super.initState();
    AppService().readAllCheckSlip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: WidgetText(
          text: 'Main Home Web',
          textStyle: AppConstant().h2Style(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: WidgetButtom(
              label: 'Manage Cat',
              pressFunc: () {
                Get.to(const ManageCatWeb());
              },
            ),
          )
        ],
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##20mar checkPaymenModel ---> ${appController.checkPaymentModels.length}');
            print('##20mar userModel ---> ${appController.userModels.length}');
            return ((appController.checkPaymentModels.isEmpty) ||
                    (appController.userModels.isEmpty))
                ? const SizedBox()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    itemCount: appController.checkPaymentModels.length,
                    itemBuilder: (context, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            WidgetImageInternet(
                                width: 200,
                                height: 200,
                                urlPath: appController
                                    .checkPaymentModels[index].urlSlip),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 200,
                              width: 200,
                              child: Column(
                                children: [
                                  displayUser(
                                      head: 'ชื่อ :',
                                      value:
                                          appController.userModels[index].name),
                                  displayUser(
                                      head: 'นามสกุล',
                                      value: appController
                                          .userModels[index].surName),
                                  displayUser(
                                      head: 'ที่อยู่',
                                      value: appController
                                          .userModels[index].address),
                                  displayUser(
                                      head: 'Approve :',
                                      value: appController
                                              .checkPaymentModels[index].approve
                                          ? 'Approved'
                                          : 'Non Approve',
                                      textColor: appController
                                              .checkPaymentModels[index].approve
                                          ? Colors.green
                                          : Colors.red),
                                  appController
                                          .checkPaymentModels[index].approve
                                      ? const SizedBox()
                                      : WidgetIconButton(
                                          iconData: Icons.approval_outlined,
                                          pressFunc: () {
                                            String? strMoney;
                                            AppDialog(context: context)
                                                .normalDialog(
                                              title: 'กรอกจำนวนเงิน',
                                              detail: '',
                                              contenWidget: WidgetForm(
                                                changeFunc: (p0) {
                                                  strMoney = p0.trim();
                                                },
                                                labelWidget: WidgetText(
                                                    text:
                                                        'กรอกจำนวนเงินเฉพาะตัวเลข'),
                                              ),
                                              firstBotton: WidgetButtom(
                                                label: 'Approve',
                                                pressFunc: () async {
                                                  if (strMoney?.isEmpty ??
                                                      true) {
                                                    Get.snackbar(
                                                        'ยังไม่กรอกจำนวนเงิน',
                                                        'กรอกจำนวนเงินด้วย');
                                                  } else {
                                                    double douMoney = 0.0;
                                                    if (appController
                                                            .userModels[index]
                                                            .money
                                                            ?.isEmpty ??
                                                        true) {
                                                    } else {
                                                      douMoney = double.parse(
                                                          appController
                                                              .userModels[index]
                                                              .money!);
                                                    }

                                                    douMoney = douMoney +
                                                        double.parse(strMoney!);
                                                    Map<String, dynamic>
                                                        mapUser = appController
                                                            .userModels[index]
                                                            .toMap();

                                                    mapUser['money'] =
                                                        douMoney.toString();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(appController
                                                            .docIdUsers[index])
                                                        .update(mapUser)
                                                        .then((value) async {
                                                      Map<String, dynamic>
                                                          mapCheckSlip =
                                                          appController
                                                              .checkPaymentModels[
                                                                  index]
                                                              .toMap();
                                                      mapCheckSlip['approve'] =
                                                          true;

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'checkslip')
                                                          .doc(appController
                                                                  .docIdCheckSlips[
                                                              index])
                                                          .update(mapCheckSlip)
                                                          .then((value) async {
                                                        AppService().processSendNoti(
                                                            title:
                                                                'ยอดเงินเข้าระบบแล้ว',
                                                            body:
                                                                'โปรดเช็คยอดเงินในโปรไฟล์ ',
                                                            token: appController
                                                                .userModels[
                                                                    index]
                                                                .token!);

                                                        Get.back();
                                                        AppService()
                                                            .readAllCheckSlip();
                                                      });
                                                    });
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }

  Row displayUser(
      {required String head, required String value, Color? textColor}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: WidgetText(
            text: head,
            textStyle: AppConstant().h3Style(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: WidgetText(
            text: value,
            textStyle: AppConstant().h3Style(color: textColor),
          ),
        ),
      ],
    );
  }
}
