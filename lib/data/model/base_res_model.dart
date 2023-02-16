// To parse this JSON data, do
//
//     final baseResModel = baseResModelFromJson(jsonString);

import 'dart:convert';

BaseResModel baseResModelFromJson(String str) =>
    BaseResModel.fromJson(json.decode(str));

String baseResModelToJson(BaseResModel data) => json.encode(data.toJson());

class BaseResModel {
  BaseResModel({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory BaseResModel.fromJson(Map<String, dynamic> json) => BaseResModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
