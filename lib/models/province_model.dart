import 'dart:convert';

class ProvinceModel {
  final String province;
  final String district;
  final String subdistrict;
  ProvinceModel({
    required this.province,
    required this.district,
    required this.subdistrict,
  });

  Map<String, dynamic> toMap() {
    return {
      'province': province,
      'district': district,
      'subdistrict': subdistrict,
    };
  }

  factory ProvinceModel.fromMap(Map<String, dynamic> map) {
    return ProvinceModel(
      province: map['province'] ?? '',
      district: map['district'] ?? '',
      subdistrict: map['subdistrict'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvinceModel.fromJson(String source) => ProvinceModel.fromMap(json.decode(source));
}
