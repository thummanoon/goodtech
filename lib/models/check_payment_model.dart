import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckPaymentModel {
  final String uidPayment;
  final String urlSlip;
  final Timestamp timestamp;
  final bool approve;
  CheckPaymentModel({
    required this.uidPayment,
    required this.urlSlip,
    required this.timestamp,
    required this.approve,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidPayment': uidPayment,
      'urlSlip': urlSlip,
      'timestamp': timestamp,
      'approve': approve,
    };
  }

  factory CheckPaymentModel.fromMap(Map<String, dynamic> map) {
    return CheckPaymentModel(
      uidPayment: map['uidPayment'] ?? '',
      urlSlip: map['urlSlip'] ?? '',
      timestamp:(map['timestamp']),
      approve: map['approve'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckPaymentModel.fromJson(String source) => CheckPaymentModel.fromMap(json.decode(source));
}
