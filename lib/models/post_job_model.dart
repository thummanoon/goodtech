import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostJobModel {
  final String barget;
  final String nameJob;
  final String namePost;
  final String plateJob;
  final String uidPost;
  final Timestamp timestampPost;
  final Timestamp timestampJob;
  final int indexStatus;
  PostJobModel({
    required this.barget,
    required this.nameJob,
    required this.namePost,
    required this.plateJob,
    required this.uidPost,
    required this.timestampPost,
    required this.timestampJob,
    required this.indexStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'barget': barget,
      'nameJob': nameJob,
      'namePost': namePost,
      'plateJob': plateJob,
      'uidPost': uidPost,
      'timestampPost': timestampPost,
      'timestampJob': timestampJob,
      'indexStatus': indexStatus,
    };
  }

  factory PostJobModel.fromMap(Map<String, dynamic> map) {
    return PostJobModel(
      barget: map['barget'] ?? '',
      nameJob: map['nameJob'] ?? '',
      namePost: map['namePost'] ?? '',
      plateJob: map['plateJob'] ?? '',
      uidPost: map['uidPost'] ?? '',
      timestampPost: (map['timestampPost']),
      timestampJob: (map['timestampJob']),
      indexStatus: map['indexStatus']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostJobModel.fromJson(String source) =>
      PostJobModel.fromMap(json.decode(source));
}
