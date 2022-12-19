import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReferanceModel {
  final String urlJob;
  final String nameJob;
  final String detail;
  final String uidTechnic;
  final Timestamp timestampJob;
  final Timestamp timestampUpdate;
  ReferanceModel({
    required this.urlJob,
    required this.nameJob,
    required this.detail,
    required this.uidTechnic,
    required this.timestampJob,
    required this.timestampUpdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'urlJob': urlJob,
      'nameJob': nameJob,
      'detail': detail,
      'uidTechnic': uidTechnic,
      'timestampJob': timestampJob,
      'timestampUpdate': timestampUpdate,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferanceModel.fromJson(String source) =>
      ReferanceModel.fromMap(json.decode(source));
}
