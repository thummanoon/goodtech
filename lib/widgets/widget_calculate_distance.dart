import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/chat_model.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:intl/intl.dart';

class WidgetCalcualteDistance extends StatelessWidget {
  const WidgetCalcualteDistance({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('docIdChats ---> ${appController.docIdChats.length}');
          return WidgetIconButton(
            iconData: Icons.social_distance,tooltip: 'แสดงระยะห่าง',
            pressFunc: () async {
              print('you Click docIdChat --> ${appController.docIdChats.last}');
              await FirebaseFirestore.instance
                  .collection('chat')
                  .doc(appController.docIdChats.last)
                  .get()
                  .then((value) async {
                ChatModel chatModel = ChatModel.fromMap(value.data()!);

                UserModel startUserModel =
                    await AppService().fineUserModel(uid: chatModel.friends[0]);

                UserModel endUserModel =
                    await AppService().fineUserModel(uid: chatModel.friends[1]);

                double distance = AppService().calculateDistance(
                    lat1: startUserModel.geoPoint.latitude,
                    lng1: startUserModel.geoPoint.longitude,
                    lat2: endUserModel.geoPoint.latitude,
                    lng2: endUserModel.geoPoint.longitude);

                NumberFormat numberFormat = NumberFormat('##0.0#', 'en_US');
                String strDistance = numberFormat.format(distance);

                AppDialog(context: context)
                    .normalDialog(title: 'ระยะห่าง', detail: '$strDistance km', );
              });
            },
          );
        });
  }
}
