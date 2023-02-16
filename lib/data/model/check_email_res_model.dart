// To parse this JSON data, do
//
//     final checkEmailResModel = checkEmailResModelFromJson(jsonString);

import 'dart:convert';

CheckEmailResModel checkEmailResModelFromJson(String str) =>
    CheckEmailResModel.fromJson(json.decode(str));

String checkEmailResModelToJson(CheckEmailResModel data) =>
    json.encode(data.toJson());

class CheckEmailResModel {
  CheckEmailResModel({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  bool error;
  bool success;
  String message;
  Data data;

  factory CheckEmailResModel.fromJson(Map<String, dynamic> json) =>
      CheckEmailResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
