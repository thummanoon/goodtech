import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String post;
  final Timestamp timestamp;
  final Map<String, dynamic> mapPost;
  PostModel({
    required this.post,
    required this.timestamp,
    required this.mapPost,
  });

  Map<String, dynamic> toMap() {
    return {
      'post': post,
      'timestamp': timestamp,
      'mapPost': mapPost,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      post: map['post'] ?? '',
      timestamp: (map['timestamp'] ?? Timestamp(0, 0)),
      mapPost: Map<String, dynamic>.from(map['mapPost'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
