import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/typeteachnic_model.dart';
import 'package:goodtech/models/user_model.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxInt indexTypeUser = 0.obs;
  RxList<UserModel> userModelLogins = <UserModel>[].obs;
  RxInt indexBody = 0.obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<File> files = <File>[].obs;
  RxList<String> typeUsers = <String>[].obs;

  Future<void> readAllTypeUser() async {
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
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
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
