// To parse this JSON data, do
//
//     final sendOtpResModel = sendOtpResModelFromJson(jsonString);

import 'dart:convert';

SendOtpResModel sendOtpResModelFromJson(String str) =>
    SendOtpResModel.fromJson(json.decode(str));

String sendOtpResModelToJson(SendOtpResModel data) =>
    json.encode(data.toJson());

class SendOtpResModel {
  SendOtpResModel({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  bool error;
  bool success;
  String message;
  Data? data;

  factory SendOtpResModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.otp,
  });

  int otp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otp: json["OTP"],
      );

  Map<String, dynamic> toJson() => {
        "OTP": otp,
      };
}
