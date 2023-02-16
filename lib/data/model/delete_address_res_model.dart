// To parse this JSON data, do
//
//     final deleteAddressResModel = deleteAddressResModelFromJson(jsonString);

import 'dart:convert';

DeleteAddressResModel deleteAddressResModelFromJson(String str) =>
    DeleteAddressResModel.fromJson(json.decode(str));

String deleteAddressResModelToJson(DeleteAddressResModel data) =>
    json.encode(data.toJson());

class DeleteAddressResModel {
  DeleteAddressResModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory DeleteAddressResModel.fromJson(Map<String, dynamic> json) =>
      DeleteAddressResModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
