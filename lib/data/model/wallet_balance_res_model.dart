// To parse this JSON data, do
//
//     final walletBalanceResModel = walletBalanceResModelFromJson(jsonString);

import 'dart:convert';

WalletBalanceResModel walletBalanceResModelFromJson(String str) =>
    WalletBalanceResModel.fromJson(json.decode(str));

String walletBalanceResModelToJson(WalletBalanceResModel data) =>
    json.encode(data.toJson());

class WalletBalanceResModel {
  WalletBalanceResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory WalletBalanceResModel.fromJson(Map<String, dynamic> json) =>
      WalletBalanceResModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.walletAmount,
  });

  int walletAmount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        walletAmount: json["wallet_amount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "wallet_amount": walletAmount,
      };
}
