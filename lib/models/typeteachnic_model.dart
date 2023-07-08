import 'dart:convert';

class TypeTeachnicModel {
  final String name;
  final String url;
  TypeTeachnicModel({
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory TypeTeachnicModel.fromMap(Map<String, dynamic> map) {
    return TypeTeachnicModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeTeachnicModel.fromJson(String source) => TypeTeachnicModel.fromMap(json.decode(source));
}
