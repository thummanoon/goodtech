import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodtech/utility/app_constant.dart';

class ReferanceModel {
  final String urlJob;
  final String nameJob;
  final String detail;
  final String uidTechnic;
  final Timestamp timestampJob;
  final Timestamp timestampUpdate;
  final String nameTechnic;
  final String urlImageTechnic;

  ReferanceModel({
    required this.urlJob,
    required this.nameJob,
    required this.detail,
    required this.uidTechnic,
    required this.timestampJob,
    required this.timestampUpdate,
    required this.nameTechnic,
    required this.urlImageTechnic,
  });

  Map<String, dynamic> toMap() {
    return {
      'urlJob': urlJob,
      'nameJob': nameJob,
      'detail': detail,
      'uidTechnic': uidTechnic,
      'timestampJob': timestampJob,
      'timestampUpdate': timestampUpdate,
      'nameTechnic': nameTechnic,
      'urlImageTechnic': urlImageTechnic,
    };
  }

  factory ReferanceModel.fromMap(Map<String, dynamic> map) {
    return ReferanceModel(
      urlJob: map['urlJob'] ?? '',
      nameJob: map['nameJob'] ?? '',
      detail: map['detail'] ?? '',
      uidTechnic: map['uidTechnic'] ?? '',
      timestampJob: (map['timestampJob']),
      timestampUpdate: (map['timestampUpdate']),
      nameTechnic: map['nameTechnic'] ?? 'NameTechnic',
      urlImageTechnic: map['urlImageTechnic'] ?? AppConstant.urlFreeProfile,
    );
  }

  // timestampJob: (map['timestampJob']),
  // timestampUpdate: (map['timestampUpdate']),

  String toJson() => json.encode(toMap());

  factory ReferanceModel.fromJson(String source) =>
      ReferanceModel.fromMap(json.decode(source));
}
