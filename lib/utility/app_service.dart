// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/check_payment_model.dart';
import 'package:goodtech/models/message_model.dart';
import 'package:goodtech/models/post_job_model.dart';
import 'package:goodtech/models/post_model.dart';
import 'package:goodtech/models/province_model.dart';
import 'package:goodtech/models/typeteachnic_model.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/utility/app_controller.dart';
import 'package:goodtech/utility/app_dialog.dart';
import 'package:goodtech/widgets/widget_buttom.dart';
import 'package:goodtech/widgets/widget_text_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/referance_modal.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> findUserModelLogin() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        print('userModel ---------> ${userModel.toMap()}');
        appController.userModelLogins.add(userModel);
      });
    }
  }

  Future<void> readFirstReferance() async {
    if (appController.referanceModels.isNotEmpty) {
      appController.referanceModels.clear();
      appController.docReferances.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .orderBy('timestampUpdate', descending: true)
        .limit(50)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          appController.referanceModels.add(model);
          appController.docReferances.add(element.id);
        }
      }
    }).catchError((onError) {
      print('##28feb onError ---> $onError');
    });
  }

  Future<void> realTimePostJob() async {
    FirebaseFirestore.instance
        .collection('postJob')
        .snapshots()
        .listen((event) {
      appController.amountNoti.value = event.docs.length;
    });
  }

  Future<void> readPostJob() async {
    if (appController.postJobModels.isNotEmpty) {
      appController.postJobModels.clear();
    }
    await FirebaseFirestore.instance
        .collection('postJob')
        .orderBy('timestampPost', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        PostJobModel postJobModel = PostJobModel.fromMap(element.data());
        appController.postJobModels.add(postJobModel);
      }
    });
  }

  Future<void> sendNotiAllTechnic(
      {required String title, required String message}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .where('typeUser', isEqualTo: 'technic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        if (userModel.token != null) {
          processSendNoti(title: title, body: message, token: userModel.token!);
        }
      }
    });
  }

  Future<void> readAllTypeTechnic() async {
    if (appController.typeTechnicModels.isNotEmpty) {
      appController.typeTechnicModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      print('value --> ${value.docs.length}');
      for (var element in value.docs) {
        TypeTeachnicModel teachnicModel =
            TypeTeachnicModel.fromMap(element.data());
        appController.typeTechnicModels.add(teachnicModel);
      }
    });
  }

  Future<ProvinceModel> findProvince(
      {required double lat, required double lng}) async {
    String urlAPI =
        'https://api.longdo.com/map/services/address?lon=$lng&lat=$lat&noelevation=1&key=655d2d823b58529039d3dd59cd082673';

    var result = await Dio().get(urlAPI);
    ProvinceModel provinceModel = ProvinceModel.fromMap(result.data);
    return provinceModel;
  }

  double calculateDistance(
      {required double lat1,
      required double lng1,
      required double lat2,
      required double lng2}) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<void> readAllCheckSlip() async {
    AppController appController = Get.put(AppController());
    if (appController.checkPaymentModels.isNotEmpty) {
      appController.checkPaymentModels.clear();
      appController.userModels.clear();
      appController.docIdUsers.clear();
      appController.docIdCheckSlips.clear();
    }

    await FirebaseFirestore.instance
        .collection('checkslip')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        CheckPaymentModel model = CheckPaymentModel.fromMap(element.data());
        appController.checkPaymentModels.add(model);
        appController.docIdUsers.add(model.uidPayment);
        appController.docIdCheckSlips.add(element.id);

        await fineUserModel(uid: model.uidPayment).then((value) {
          appController.userModels.add(value);
        });
      }
    });
  }

  Future<void> processPayMoneyForChat({required String docIdChat}) async {
    AppController appController = Get.put(AppController());
    Map<String, dynamic> map = appController.userModelLogins.last.toMap();
    print('##6jan ก่อนตัด $map');

    double douMoney = double.parse(map['money']);
    douMoney = douMoney - 32.10;

    map['money'] = douMoney.toString();
    List<String> docIdChats = map['docIdChats'];
    docIdChats.add(docIdChat);
    print('##6jan หลังตัด $map');

    await FirebaseFirestore.instance
        .collection('user')
        .doc(appController.uidLogins.last)
        .update(map)
        .then((value) {
      print('##6jan PayMoney Succss');
    });
  }

  Future<void> processInsertSlip(
      {required CheckPaymentModel checkPaymentModel}) async {
    await FirebaseFirestore.instance
        .collection('checkslip')
        .doc()
        .set(checkPaymentModel.toMap())
        .then((value) => print('##6jan Insert Slip Success'));
  }

  Future<void> processSendNoti(
      {required String title,
      required String body,
      required String token}) async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/noti/apiNotiThummanoon.php?isAdd=true&token=$token&title=$title&body=$body';
    await Dio().get(urlAPI).then((value) {
      print('##28dec Sent Noti Success');
    });
  }

  Future<void> processSendNotiByUid(
      {required String title,
      required String body,
      required String uid}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) async {
      if (value.data() != null) {
        UserModel userModel = UserModel.fromMap(value.data()!);

        String urlAPI =
            'https://www.androidthai.in.th/fluttertraining/noti/apiNotiThummanoon.php?isAdd=true&token=${userModel.token}&title=$title&body=$body';
        await Dio().get(urlAPI).then((value) {
          print('##28dec Sent Noti Success');
        });
      }
    });
  }

  Future<void> insertMessage({required MessageModel messageModel}) async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(appController.docIdChats.last)
        .collection('message')
        .doc()
        .set(messageModel.toMap())
        .then((value) {
      print('##28dec insert chat Succes');
    });
  }

  Future<void> monitorNoti({required BuildContext context}) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    AppController appController = Get.put(AppController());
    var user = FirebaseAuth.instance.currentUser;

    FirebaseMessaging.onMessage.listen((event) {
      print('##28dec onMessage Work');
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      AppDialog(context: context).normalDialog(title: title!, detail: body!);
      appController.findUserModel(uid: user!.uid);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      AppDialog(context: context).normalDialog(title: title!, detail: body!);
      appController.findUserModel(uid: user!.uid);
    });
  }

  Future<void> processUploadToken({required String token}) async {
    AppController appController = Get.put(AppController());

    await findUserModelLogin().then((value) async {
      Map<String, dynamic> map = appController.userModelLogins.last.toMap();
      print('##25dec map --> $map');

      map['token'] = token;
      String docIdUser = appController.uidLogins.last;
      print('##25dec map update token --> $map');
      print('##25dec docIdUser --> $docIdUser');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(docIdUser)
          .update(map)
          .then((value) {
        print('##25dec Success Update');
      });
    });
  }

  Future<List<String>> findDocIdUserWhereEmail({required String email}) async {
    var strings = <String>[];
    var resule = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    for (var element in resule.docs) {
      strings.add(element.id);
    }
    return strings;
  }

  Future<UserModel> fineUserModel({required String uid}) async {
    var result =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    UserModel userModel = UserModel.fromMap(result.data()!);
    return userModel;
  }

  String cutWord({required String word, required int length}) {
    String result = word;
    if (result.length >= length) {
      result = result.substring(0, length);
      result = '$result...';
    }
    return result;
  }

  String dateTimeToString({required DateTime dateTime, String? format}) {
    DateFormat dateFormat = DateFormat(format ?? 'dd MMM yyyy');
    return dateFormat.format(dateTime);
  }

  Future<String?> processUploadImage({required String path}) async {
    AppController appController = Get.put(AppController());
    String? urlImage;

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(path);
    UploadTask uploadTask = reference.putFile(appController.files[0]);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) {
        urlImage = value.toString();
        appController.files.clear();
      });
    });
    return urlImage;
  }

  Future<File?> processTakePhoto({required ImageSource source}) async {
    File? file;
    var result = await ImagePicker()
        .pickImage(source: source, maxWidth: 800, maxHeight: 800);
    if (result != null) {
      file = File(result.path);
    }
    return file;
  }

  bool checkChooseTypeTechnic({required List<bool> listChooses}) {
    bool result = true;

    for (var element in listChooses) {
      if (result) {
        if (element) {
          result = false;
        }
      }
    }

    return result;
  }

  Future<void> processCreateNewAccount({
    required String email,
    required String password,
    required BuildContext context,
    required UserModel userModel,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String uid = value.user!.uid;
      print('uid = $uid');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        // Get.offAllNamed(AppConstant.pageMainHome);

        AppDialog(context: context).normalDialog(
            title: 'สมัครสมาชิกสำเร็จ',
            detail: 'กรุณาล็อคอินเข้าใหม่',
            firstBotton: WidgetButtom(
              label: 'OK',
              pressFunc: () {
                exit(0);
              },
            ));
      });
    }).catchError((onError) {
      AppDialog(context: context)
          .normalDialog(title: onError.code, detail: onError.message);
    });
  }

  Future<Position?> processFindPosition({required BuildContext context}) async {
    Position? position;
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if (locationServiceEnable) {
      //Open Service

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        //ไม่อนุญาติเลย
        dialogOpenPermission(context);
      } else {
        if (permission == LocationPermission.denied) {
          //ยังไม่รู้
          permission = await Geolocator.requestPermission();
          if ((permission != LocationPermission.whileInUse) &&
              (permission != LocationPermission.always)) {
            //Denied Forver
            dialogOpenPermission(context);
          } else {
            position = await Geolocator.getCurrentPosition();
          }
        } else {
          position = await Geolocator.getCurrentPosition();
        }
      }
    } else {
      // Off Service
      AppDialog(context: context).normalDialog(
          title: 'Off Location ?',
          detail: 'กรุณาเปิด Location Service',
          secondBotton: WidgetTextButton(
            label: 'กรุณาเปิด Location',
            pressFunc: () {
              Geolocator.openLocationSettings();
              exit(0);
            },
          ));
    }

    return position;
  }

  void dialogOpenPermission(BuildContext context) {
    AppDialog(context: context).normalDialog(
        title: 'ไม่อนุญาติแชร์พิกัด ?>',
        detail: 'กรุณา อนุญาติแชร์พิกัดด้วย',
        secondBotton: WidgetTextButton(
          label: 'อนุญาติ แชร์พิกัด',
          pressFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }
}
