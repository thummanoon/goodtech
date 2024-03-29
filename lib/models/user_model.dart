import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String surName;
  final String address;
  final String phone;
  final String email;
  final String password;
  final String typeUser;
  final List<String>? skillTechnic;
  final GeoPoint geoPoint;
  final String? urlProfile;
  final String? token;
  final List<String>? docIdChats;
  final String? money;

  UserModel({
    required this.name,
    required this.surName,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.typeUser,
    this.skillTechnic,
    required this.geoPoint,
    this.urlProfile,
    this.token,
    this.docIdChats,
    this.money,
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
      'skillTechnic': skillTechnic,
      'geoPoint': geoPoint,
      'urlProfile': urlProfile,
      'token': token,
      'docIdChats': docIdChats,
      'money': money,
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
      skillTechnic: List<String>.from(map['skillTechnic'] ?? []),
      geoPoint: (map['geoPoint'] ?? const GeoPoint(0, 0)),
      urlProfile: map['urlProfile'] ?? '',
      token: map['token'] ?? '',
      docIdChats: List<String>.from(map['docIdChats'] ?? []),
      money: map['money'] ?? '',
    );
  }

  // skillTechnic: List<String>.from(map['skillTechnic'] ?? []),
  //     geoPoint: (map['geoPoint'] ?? const GeoPoint(0, 0)),
  //     urlProfile: map['urlProfile'] ?? '',
  //     token: map['token'] ?? '',
  //     docIdChats: List<String>.from(map['docIdChats'] ?? []),
  //     money: map['money'] ?? 0.0,
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
