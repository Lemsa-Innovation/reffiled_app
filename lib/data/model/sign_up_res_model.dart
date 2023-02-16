import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

SignUpResModel signUpResModelFromJson(String str) =>
    SignUpResModel.fromJson(json.decode(str));

String signUpResModelToJson(SignUpResModel data) => json.encode(data.toJson());

class SignUpResModel {
  SignUpResModel({
    this.error,
    this.success = false,
    this.message = '',
    this.userData,
    this.token,
  });

  bool? error;
  bool success;
  String message;
  UserData? userData;
  String? token;

  factory SignUpResModel.fromJson(Map<String, dynamic> json) => SignUpResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        userData: json["data"] == null ? null : UserData.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
        "data": userData == null ? null : userData!.toJson(),
        "token": token,
      };

  static Future<SignUpResModel?> load() async {
    var pref = await SharedPreferences.getInstance();
    var info = pref.getString('user');
    if (info == null) return null;
    return SignUpResModel.fromJson(jsonDecode(info));
  }

  Future<void> save() async => (await SharedPreferences.getInstance())
      .setString('user', jsonEncode(toJson()));

  SignUpResModel copyWith(Map<String, dynamic> userData) => SignUpResModel(
      userData: UserData.fromJson(userData),
      error: error,
      message: message,
      success: success,
      token: token);
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.isDeleted,
    this.deviceId,
    this.loginType,
    this.deviceType,
    this.socialToken,
    this.latitude,
    this.longitude,
    this.fcmToken,
    this.isActive,
    this.createdDtm,
  });

  int? id;
  String? name;
  String? email;
  String? mobile;
  int? isDeleted;
  String? deviceId;
  String? loginType;
  String? deviceType;
  String? socialToken;
  String? latitude;
  String? longitude;
  String? fcmToken;
  int? isActive;
  DateTime? createdDtm;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
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
        createdDtm: json["createdDtm"] == null
            ? null
            : DateTime.parse(json["createdDtm"]),
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
        "createdDtm": createdDtm == null ? null : createdDtm!.toIso8601String(),
      };
}
