import 'dart:convert';

AddAddressResModel addAddressResModelFromJson(String str) =>
    AddAddressResModel.fromJson(json.decode(str));

String addAddressResModelToJson(AddAddressResModel data) =>
    json.encode(data.toJson());

class AddAddressResModel {
  AddAddressResModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory AddAddressResModel.fromJson(Map<String, dynamic> json) =>
      AddAddressResModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
