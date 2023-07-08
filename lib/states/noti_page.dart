import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/payment_page.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_text.dart';
import 'package:goodtech/widgets/widget_text_button.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({Key? key}) : super(key: key);

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  @override
  void initState() {
    super.initState();
    AppService().readPostJob();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Scaffold(
            appBar: AppBar(
              title: WidgetText(text: 'แจ้งเตือน'),
            ),
            body: appController.postJobModels.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    itemCount: appController.postJobModels.length,
                    itemBuilder: (context, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              text:
                                  'เจ้าของงาน : ${appController.postJobModels[index].namePost} ',
                              textStyle:
                                  AppConstant().h3Style(color: Colors.red),
                            ),
                            WidgetText(
                              text: appController.postJobModels[index].nameJob,
                              textStyle: AppConstant().h2Style(),
                            ),
                            WidgetText(
                              text:
                                  'งบประมาณ : ${appController.postJobModels[index].barget} บาท',
                              textStyle:
                                  AppConstant().h3Style(color: Colors.red),
                            ),
                            WidgetText(
                              text:
                                  'วันเริ่มงาน : ${AppService().dateTimeToString(dateTime: appController.postJobModels[index].timestampJob.toDate(), format: "dd MMM yyyy HH:mm")} ',
                              textStyle:
                                  AppConstant().h3Style(color: Colors.green),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetText(
                                  text:
                                      'สถานที่ : ${appController.postJobModels[index].plateJob} ',
                                  textStyle: AppConstant()
                                      .h2Style(color: Colors.green),
                                ),
                                WidgetTextButton(
                                  label: 'รับงาน..',
                                  pressFunc: () async {
                                    if (appController
                                            .userModelLogins.last.typeUser ==
                                        'technic') {
                                      // technic

                                      String money = appController
                                          .userModelLogins.last.money!;

                                      if (money.isEmpty) {
                                        dialogRequire(context);
                                      } else if (double.parse(money) < 32.10) {
                                        dialogRequire(context,
                                            title:
                                                'จำนวนเงินในกระเป๋าเงินไม่พอ',
                                            detail: 'กรุณาเติมเงิน',
                                            label: 'เติมเงิน');
                                      } else {
                                        // จ่านเงินเรียบร้อยแล้ว แอดมินอนุมัติ

                                        await FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(appController
                                                .postJobModels[index].uidPost)
                                            .get()
                                            .then((value) {
                                          UserModel model =
                                              UserModel.fromMap(value.data()!);

                                          AppService().processSendNoti(
                                              title: 'มีช่างกดรับงานแล้ว',
                                              body: 'ขอรายละเอียดงานเพิ่มเติม',
                                              token: model.token!);
                                        });
                                      }
                                    } else {
                                      Get.snackbar(
                                          'For Technic', 'สำหรับช่างเท่านั้น');
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  void dialogRequire(BuildContext context,
      {String? title, String? detail, String? label}) {
    AppDialog(context: context).normalDialog(
      title: title ?? 'ยังไม่มีสิทธิ์ Chat',
      detail: detail ?? 'กรุณาเปิดสิทธิ์เข้าใช้งาน',
      firstBotton: WidgetTextButton(
        label: label ?? 'เปิดสิทธิ์ใช้งาน',
        pressFunc: () {
          Get.back();
          Get.to(const PaymentPage());
        },
      ),
    );
  }
}
