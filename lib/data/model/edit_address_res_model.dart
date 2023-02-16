// To parse this JSON data, do
//
//     final editAddressResModel = editAddressResModelFromJson(jsonString);

import 'dart:convert';

EditAddressResModel editAddressResModelFromJson(String str) =>
    EditAddressResModel.fromJson(json.decode(str));

String editAddressResModelToJson(EditAddressResModel data) =>
    json.encode(data.toJson());

class EditAddressResModel {
  EditAddressResModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory EditAddressResModel.fromJson(Map<String, dynamic> json) =>
      EditAddressResModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
