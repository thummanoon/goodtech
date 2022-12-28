import 'dart:convert';

class ChatModel {
  final List<String> friends;
  ChatModel({
    required this.friends,
  });

  Map<String, dynamic> toMap() {
    return {
      'friends': friends,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      friends: List<String>.from(map['friends'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source));
}
