import 'dart:convert';

CheckMobileResModel checkMobileResModelFromJson(String str) =>
    CheckMobileResModel.fromJson(json.decode(str));

String checkMobileResModelToJson(CheckMobileResModel data) =>
    json.encode(data.toJson());

class CheckMobileResModel {
  CheckMobileResModel({
    required this.error,
    required this.success,
    required this.message,
  });

  bool error;
  bool success;
  String message;

  factory CheckMobileResModel.fromJson(Map<String, dynamic> json) =>
      CheckMobileResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
      };
}
