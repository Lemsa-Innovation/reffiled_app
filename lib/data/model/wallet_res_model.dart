// To parse this JSON data, do
//
//     final walletResModel = walletResModelFromJson(jsonString);

import 'dart:convert';

WalletResModel walletResModelFromJson(String str) =>
    WalletResModel.fromJson(json.decode(str));

String walletResModelToJson(WalletResModel data) => json.encode(data.toJson());

class WalletResModel {
  WalletResModel({
    required this.success,
    required this.message,
    required this.data,
    required this.walletAmount,
  });

  bool success;
  String message;
  List<Referral> data;
  int walletAmount;

  factory WalletResModel.fromJson(Map<String, dynamic> json) => WalletResModel(
        success: json["success"],
        message: json["message"],
        data:
            List<Referral>.from(json["data"].map((x) => Referral.fromJson(x))),
        walletAmount: json["wallet_amount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "wallet_amount": walletAmount,
      };
}

class Referral {
  Referral({
    required this.id,
    required this.userId,
    required this.description,
    required this.type,
    required this.amount,
    required this.createdDtm,
  });

  int id;
  int userId;
  String description;
  String type;
  int amount;
  DateTime createdDtm;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json["id"],
        userId: json["user_id"],
        description: json["description"],
        type: json["type"],
        amount: json["amount"],
        createdDtm: DateTime.parse(json["createdDtm"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "description": description,
        "type": type,
        "amount": amount,
        "createdDtm": createdDtm.toIso8601String(),
      };
}
