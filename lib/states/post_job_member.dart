import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:goodtech/models/post_job_model.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/utility/app_service.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_form.dart';
import 'package:goodtech/widgets/widget_icon_button.dart';
import 'package:goodtech/widgets/widget_text.dart';

class PostJobMember extends StatefulWidget {
  const PostJobMember({Key? key}) : super(key: key);

  @override
  State<PostJobMember> createState() => _PostJobMemberState();
}

class _PostJobMemberState extends State<PostJobMember> {
  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  String? name, plate, barget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(text: 'ประกาศงานหาช่าง'),
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('jobDateTime ---> ${appController.jobDateTimes.length}');
            return ListView(
              children: [
                nameForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetText(
                        text: appController.jobDateTimes.isEmpty
                            ? 'dd/mmm/yyyy'
                            : AppService().dateTimeToString(
                                dateTime: appController.jobDateTimes.last)),
                    WidgetIconButton(
                      iconData: Icons.calendar_month,
                      pressFunc: () async {
                        await showDatePicker(
                                context: context,
                                initialDate: dateTime,
                                firstDate: dateTime,
                                lastDate: DateTime(dateTime.year + 1))
                            .then((value) {
                          if (value != null) {
                            appController.jobDateTimes.add(value);
                          }
                        });
                      },
                    )
                  ],
                ),
                appController.jobDateTimes.isEmpty
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetText(
                            text: appController.jobTimeOfDates.isEmpty
                                ? 'HH:mm'
                                : AppService().dateTimeToString(
                                    dateTime: DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day,
                                        appController.jobTimeOfDates.last.hour,
                                        appController
                                            .jobTimeOfDates.last.minute),
                                    format: 'HH:mm'),
                          ),
                          WidgetIconButton(
                            iconData: Icons.watch_later_outlined,
                            pressFunc: () async {
                              await showTimePicker(
                                      context: context, initialTime: timeOfDay)
                                  .then((value) {
                                if (value != null) {
                                  appController.jobTimeOfDates.add(value);
                                }
                              });
                            },
                          )
                        ],
                      ),
                plateForm(),
                bargetForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetButtom(
                      label: 'ประกาศ',
                      pressFunc: () async {
                        if ((name?.isEmpty ?? true) ||
                            (plate?.isEmpty ?? true)) {
                          AppDialog(context: context).normalDialog(
                              title: 'มีช่องว่าง',
                              detail: 'ต้องมีชื่องาน และสถานที่');
                        } else if (appController.jobDateTimes.isEmpty) {
                          AppDialog(context: context).normalDialog(
                              title: 'วันที่เริ่มงาน',
                              detail: 'กรุณาระบุวันที่');
                        } else if (appController.jobTimeOfDates.isEmpty) {
                          AppDialog(context: context).normalDialog(
                              title: 'เวลาเริ่มงาน', detail: 'กรุณาเลือกเวลา');
                        } else {
                          DateTime jobDateTime = DateTime(
                              appController.jobDateTimes.last.year,
                              appController.jobDateTimes.last.month,
                              appController.jobDateTimes.last.day,
                              appController.jobTimeOfDates.last.hour,
                              appController.jobTimeOfDates.last.minute);
                          PostJobModel postJobModel = PostJobModel(
                              barget: barget ?? '',
                              nameJob: name!,
                              namePost: appController.userModelLogins.last.name,
                              plateJob: plate!,
                              uidPost: appController.uidLogins.last,
                              timestampPost: Timestamp.fromDate(dateTime),
                              timestampJob: Timestamp.fromDate(jobDateTime),
                              indexStatus: 0);

                          await FirebaseFirestore.instance
                              .collection('postJob')
                              .doc()
                              .set(postJobModel.toMap())
                              .then((value) {
                            appController.jobDateTimes.clear();
                            appController.jobTimeOfDates.clear();

                            AppService().sendNotiAllTechnic(
                                title: name! , message: 'งบประมาณ $barget');

                            // Get.back();
                          });
                        }
                      },
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }

  Row nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          changeFunc: (p0) {
            name = p0.trim();
          },
          labelWidget: const WidgetText(text: 'ชื่องาน'),
        ),
      ],
    );
  }

  Row plateForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          changeFunc: (p0) {
            plate = p0.trim();
          },
          labelWidget: WidgetText(text: 'สถานที่'),
        ),
      ],
    );
  }

  Row bargetForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          changeFunc: (p0) {
            barget = p0.trim();
          },
          labelWidget: WidgetText(text: 'งบประมาณ'),
        ),
      ],
    );
  }
}
