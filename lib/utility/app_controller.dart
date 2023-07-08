import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodtech/models/banner_model.dart';
import 'package:goodtech/models/chat_model.dart';
import 'package:goodtech/models/check_payment_model.dart';
import 'package:goodtech/models/message_model.dart';
import 'package:goodtech/models/post_job_model.dart';
import 'package:goodtech/models/province_model.dart';
import 'package:goodtech/models/referance_modal.dart';
import 'package:goodtech/models/typeteachnic_model.dart';
import 'package:goodtech/models/user_model.dart';
import 'package:goodtech/states/post_job_member.dart';
import 'package:goodtech/utility/app_constant.dart';
import 'package:goodtech/utility/app_service.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxInt indexTypeUser = 0.obs;
  RxInt indexBody = 0.obs;
  RxBool loadReferance = true.obs;
  RxList<UserModel> userModelLogins = <UserModel>[].obs;

  RxList<String> uidLogins = <String>[].obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<String> docIdUsers = <String>[].obs;
  RxList<File> files = <File>[].obs;
  RxList<String> typeUsers = <String>[].obs;
  RxList<ReferanceModel> referanceModels = <ReferanceModel>[].obs;
  RxList<BannerModel> bannerModels = <BannerModel>[].obs;

  RxList<UserModel> technicUserModels = <UserModel>[].obs;
  RxList<UserModel> haveImagetechnicUserModels = <UserModel>[].obs;

  RxList<String> docIdChats = <String>[].obs;
  RxList<String> messageChats = <String>[].obs;
  RxList<MessageModel> messageModels = <MessageModel>[].obs;
  RxList<String> docIdChatUserTechnics = <String>[].obs;
  RxList<ChatModel> chatModelUserTechnic = <ChatModel>[].obs;
  RxList<String> nameUserOrTechnics = <String>[].obs;
  RxList<String> lastMessages = <String>[].obs;
  RxList chatModels = <ChatModel>[].obs;
  RxList nameFriends = <String>[].obs;
  RxList userModelTechnicForUsers = <UserModel>[].obs;
  RxList<CheckPaymentModel> checkPaymentModels = <CheckPaymentModel>[].obs;
  RxList<String> docIdCheckSlips = <String>[].obs;
  RxList<UserModel> userModelDisplayTechnic = <UserModel>[].obs;
  RxList<ProvinceModel> provinceModels = <ProvinceModel>[].obs;
  RxInt indexBodyMobile = 0.obs;
  RxList<DateTime> jobDateTimes = <DateTime>[].obs;
  RxList<TimeOfDay> jobTimeOfDates = <TimeOfDay>[].obs;

  RxList<TypeTeachnicModel> typeTechnicModels = <TypeTeachnicModel>[].obs;
  RxList<PostJobModel> postJobModels = <PostJobModel>[].obs;
  RxInt amountNoti = 0.obs;

  Future<void> readChatModelForUser() async {
    if (chatModels.isNotEmpty) {
      chatModels.clear();
      nameFriends.clear();
      userModelTechnicForUsers.clear();
    }
    await FirebaseFirestore.instance.collection('chat').get().then((value) {
      for (var element in value.docs) {
        ChatModel model = ChatModel.fromMap(element.data());
        if (model.friends.contains(uidLogins.last)) {
          chatModels.add(model);

          for (var element2 in model.friends) {
            if (element2 != uidLogins.last) {
              String uidFriend = element2;
              print('##30jan uidFriend ---> $element2');

              AppService().fineUserModel(uid: element2).then((value) {
                userModelTechnicForUsers.add(value);
                nameFriends.add(value.name);
              });
            }
          }
        }
      }
    });
  }

  Future<void> readDocIdChatUserTechnics({required String uid}) async {
    if (docIdChatUserTechnics.isNotEmpty) {
      docIdChatUserTechnics.clear();
      chatModelUserTechnic.clear();
      nameUserOrTechnics.clear();
      lastMessages.clear();
    }
    await FirebaseFirestore.instance
        .collection('chat')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ChatModel chatModel = ChatModel.fromMap(element.data());
          if (chatModel.friends.contains(uid)) {
            docIdChatUserTechnics.add(element.id);
            chatModelUserTechnic.add(chatModel);

            var friends = chatModel.friends;
            friends.remove(uid);

            await AppService().fineUserModel(uid: friends.last).then((value) {
              nameUserOrTechnics.add(value.name);
            });

            await FirebaseFirestore.instance
                .collection('chat')
                .doc(element.id)
                .collection('message')
                .orderBy('timestamp')
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                MessageModel? messageModel;
                for (var element in value.docs) {
                  messageModel = MessageModel.fromMap(element.data());
                }
                lastMessages.add(messageModel?.message ?? 'Last Message');
              } else {
                lastMessages.add('');
              }
            });
          }
        }
      }
    });
  }

  Future<void> readMessageModels() async {
    if (docIdChats.isNotEmpty) {
      print('##28dec docId --> ${docIdChats.last}');

      await FirebaseFirestore.instance
          .collection('chat')
          .doc(docIdChats.last)
          .collection('message')
          .orderBy('timestamp')
          .snapshots()
          .listen((event) {
        if (messageModels.isNotEmpty) {
          messageModels.clear();
        }

        if (event.docs.isNotEmpty) {
          for (var element in event.docs) {
            MessageModel messageModel = MessageModel.fromMap(element.data());
            messageModels.add(messageModel);
          }
        }
      });
    }
  }

  Future<void> findDocIdChats(
      {required String uidLogin, required String uidFriend}) async {
    if (docIdChats.isNotEmpty) {
      docIdChats.clear();
    }

    await FirebaseFirestore.instance
        .collection('chat')
        .get()
        .then((value) async {
      bool createDocument = true;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ChatModel chatModel = ChatModel.fromMap(element.data());
          if ((chatModel.friends.contains(uidLogin)) &&
              (chatModel.friends.contains(uidFriend))) {
            docIdChats.add(element.id);
            createDocument = false;
            readMessageModels();
          }
        }

        if (createDocument) {
          await createNewChat(uidLogin, uidFriend);
        }
      } else {
        createNewChat(uidLogin, uidFriend);
      }
    });
  }

  Future<void> createNewChat(String uidLogin, String uidFriend) async {
    var friends = <String>[];
    friends.add(uidLogin);
    friends.add(uidFriend);
    ChatModel model = ChatModel(friends: friends);

    await FirebaseFirestore.instance
        .collection('chat')
        .doc()
        .set(model.toMap())
        .then((value) {
      findDocIdChats(uidLogin: uidLogin, uidFriend: uidFriend);
    });
  }

  Future<void> readTechnicUserModel() async {
    if (technicUserModels.isNotEmpty) {
      technicUserModels.clear();
      haveImagetechnicUserModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('user')
        .where('typeUser', isEqualTo: AppConstant.typeUsers[1])
        .get()
        .then((value) {
      for (var element in value.docs) {
        UserModel model = UserModel.fromMap(element.data());
        technicUserModels.add(model);
        if (model.urlProfile!.isNotEmpty) {
          haveImagetechnicUserModels.add(model);
        }
      }
    });
  }

  Future<void> readBanner() async {
    if (bannerModels.isNotEmpty) {
      bannerModels.clear();
    }

    await FirebaseFirestore.instance.collection('banner').get().then((value) {
      for (var element in value.docs) {
        BannerModel model = BannerModel.fromMap(element.data());
        bannerModels.add(model);
      }
    });
  }

  Future<void> readAllReferance() async {
    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .get()
        .then((value) async {
      loadReferance.value = false;

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ReferanceModel model = ReferanceModel.fromMap(element.data());
          referanceModels.add(model);
        }
      }
    });
  }

  Future<void> readTechReferance({String? uidTechnic}) async {
    var user = FirebaseAuth.instance.currentUser;

    String uid = user!.uid;

    if (uidTechnic != null) {
      uid = uidTechnic;
    }

    if (referanceModels.isNotEmpty) {
      referanceModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('referance')
        .where('uidTechnic', isEqualTo: uid)
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
