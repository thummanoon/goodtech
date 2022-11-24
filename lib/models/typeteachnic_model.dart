import 'dart:convert';

class TypeTeachnicModel {
  
  final String name;
  TypeTeachnicModel({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory TypeTeachnicModel.fromMap(Map<String, dynamic> map) {
    return TypeTeachnicModel(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeTeachnicModel.fromJson(String source) => TypeTeachnicModel.fromMap(json.decode(source));
}
