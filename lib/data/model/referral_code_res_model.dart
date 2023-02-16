// To parse this JSON data, do
//
//     final referralCodeResModel = referralCodeResModelFromJson(jsonString);

import 'dart:convert';

ReferralCodeResModel referralCodeResModelFromJson(String str) =>
    ReferralCodeResModel.fromJson(json.decode(str));

String referralCodeResModelToJson(ReferralCodeResModel data) =>
    json.encode(data.toJson());

class ReferralCodeResModel {
  ReferralCodeResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data? data;

  factory ReferralCodeResModel.fromJson(Map<String, dynamic> json) =>
      ReferralCodeResModel(
        success: json["success"],
        message: json["message"],
        data: json.containsKey('data') ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.referralCode,
  });

  String referralCode;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        referralCode: json["referral_code"],
      );

  Map<String, dynamic> toJson() => {
        "referral_code": referralCode,
      };
}
