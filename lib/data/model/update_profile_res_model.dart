// To parse this JSON data, do
//
//     final updateProfileResModel = updateProfileResModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileResModel updateProfileResModelFromJson(String str) =>
    UpdateProfileResModel.fromJson(json.decode(str));

String updateProfileResModelToJson(UpdateProfileResModel data) =>
    json.encode(data.toJson());

class UpdateProfileResModel {
  UpdateProfileResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  ProfileData data;

  factory UpdateProfileResModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResModel(
        success: json["success"],
        message: json["message"],
        data: ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.isDeleted,
    required this.deviceId,
    required this.loginType,
    required this.deviceType,
    required this.socialToken,
    required this.latitude,
    required this.longitude,
    required this.fcmToken,
    required this.isActive,
    required this.createdDtm,
  });

  int id;
  String name;
  String email;
  String mobile;
  int isDeleted;
  String deviceId;
  String loginType;
  String deviceType;
  String socialToken;
  String latitude;
  String longitude;
  String fcmToken;
  int isActive;
  DateTime createdDtm;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        name: json["name"],
        email: json["email"] ?? '',
        mobile: json["mobile"],
        isDeleted: json["isDeleted"],
        deviceId: json["deviceId"],
        loginType: json["loginType"],
        deviceType: json["deviceType"],
        socialToken: json["socialToken"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        fcmToken: json["fcmToken"],
        isActive: json["isActive"],
        createdDtm: DateTime.parse(json["createdDtm"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "isDeleted": isDeleted,
        "deviceId": deviceId,
        "loginType": loginType,
        "deviceType": deviceType,
        "socialToken": socialToken,
        "latitude": latitude,
        "longitude": longitude,
        "fcmToken": fcmToken,
        "isActive": isActive,
        "createdDtm": createdDtm.toIso8601String(),
      };
}
