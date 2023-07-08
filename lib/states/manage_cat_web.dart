import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_image_internet.dart';
import 'package:goodtech/widgets/widget_text.dart';

class ManageCatWeb extends StatefulWidget {
  const ManageCatWeb({Key? key}) : super(key: key);

  @override
  State<ManageCatWeb> createState() => _ManageCatWebState();
}

class _ManageCatWebState extends State<ManageCatWeb> {
  @override
  void initState() {
    super.initState();
    AppService().readAllTypeTechnic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: WidgetText(
          text: 'Manage Catigory',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                'typeTechnicModels ---> ${appController.typeTechnicModels.length}');
            return appController.typeTechnicModels.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    itemCount: appController.typeTechnicModels.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WidgetImageInternet(
                            urlPath: appController.typeTechnicModels[index].url,
                            width: 64,
                            height: 64,
                          ),
                        ),
                        WidgetText(
                            text: appController.typeTechnicModels[index].name),
                      ],
                    ),
                  );
          }),
      floatingActionButton: WidgetButtom(
        label: 'Add Category',
        pressFunc: () {},
      ),
    );
  }
}
