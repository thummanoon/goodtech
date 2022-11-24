import 'dart:convert';

class UserModel {
  final String name;
  final String surName;
  final String address;
  final String phone;
  final String email;
  final String password;
  final String typeUser;
  UserModel({
    required this.name,
    required this.surName,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.typeUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surName': surName,
      'address': address,
      'phone': phone,
      'email': email,
      'password': password,
      'typeUser': typeUser,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      surName: map['surName'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      typeUser: map['typeUser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
