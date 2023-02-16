import 'dart:convert';

ApplyPromoResModel applyPromoResModelFromJson(String str) =>
    ApplyPromoResModel.fromJson(json.decode(str));

String applyPromoResModelToJson(ApplyPromoResModel data) =>
    json.encode(data.toJson());

class ApplyPromoResModel {
  ApplyPromoResModel({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  Data? data;

  factory ApplyPromoResModel.fromJson(Map<String, dynamic> json) =>
      ApplyPromoResModel(
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
    required this.id,
    required this.code,
    required this.value,
    required this.validUpto,
    required this.createdDtm,
  });

  int id;
  String code;
  int value;
  String validUpto;
  DateTime createdDtm;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        code: json["code"],
        value: json["value"],
        validUpto: json["valid_upto"],
        createdDtm: DateTime.parse(json["createdDtm"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "value": value,
        "valid_upto": validUpto,
        "createdDtm": createdDtm.toIso8601String(),
      };
}
