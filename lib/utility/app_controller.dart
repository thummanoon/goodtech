import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/referance_modal.dart';
import 'package:goodtech/models/typeteachnic_model.dart';
import 'package:goodtech/models/user_model.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxInt indexTypeUser = 0.obs;
  RxInt indexBody = 0.obs;
  RxBool loadReferance = true.obs;

  RxList<UserModel> userModelLogins = <UserModel>[].obs;
  RxList<String> uidLogins = <String>[].obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<File> files = <File>[].obs;
  RxList<String> typeUsers = <String>[].obs;
  RxList<ReferanceModel> referanceModels = <ReferanceModel>[].obs;

  Future<void> readAllReferance() async {
    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .get()
        .then((value) {
      loadReferance.value = false;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          referanceModels.add(model);
        }
      }
    });
  }

  Future<void> readTechReferance() async {
    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    var user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('referance')
        .where('uidTechnic', isEqualTo: user!.uid)
        .get()
        .then((value) {
      loadReferance.value = false;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          referanceModels.add(model);
        }
      }
    });
  }

  Future<void> readAllTypeUser() async {
    if (typeUsers.isNotEmpty) {
      typeUsers.clear();
    }

    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TypeTeachnicModel typeTeachnicModel =
            TypeTeachnicModel.fromMap(element.data());
        typeUsers.add(typeTeachnicModel.name);
      }
    });
  }

  Future<void> findUserModel({required String uid}) async {
    if (userModels.isNotEmpty) {
      userModels.clear();
    }
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      UserModel userModel = UserModel.fromMap(value.data()!);
      userModels.add(userModel);
    });
  }

  Future<void> findUserModelLogin() async {
    if (userModelLogins.isNotEmpty) {
      userModelLogins.clear();
      uidLogins.clear();
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      uidLogins.add(user.uid);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        print('userModel ---------> ${userModel.toMap()}');
        userModelLogins.add(userModel);
      });
    }
  }
}
