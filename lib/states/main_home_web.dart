import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
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
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                'checkPaymenModel ---> ${appController.checkPaymentModels.length}');
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
                              width: 300,
                              child: Column(
                                children: [
                                  displayUser(head: 'ชื่อ :', value: appController.userModels[index].name),
                                  displayUser(head: 'นามสกุล', value: appController.userModels[index].surName),
                                  displayUser(head: 'ที่อยู่', value: appController.userModels[index].address),
                                  displayUser(head: 'Approve :', value: appController.checkPaymentModels[index].approve ? 'Approved' : 'Non Approve' )
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

  Row displayUser({required String head, required String value, Color? textColor}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: WidgetText(
            text: head,
            textStyle: AppConstant().h3Style(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: WidgetText(text: value, textStyle: AppConstant().h3Style(color: textColor),),
        ),
      ],
    );
  }
}
