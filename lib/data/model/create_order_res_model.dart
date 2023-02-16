// To parse this JSON data, do
//
//     final createOrder = createOrderFromMap(jsonString);

import 'dart:convert';

CreateOrder createOrderFromMap(String str) =>
    CreateOrder.fromMap(json.decode(str));

String createOrderToMap(CreateOrder data) => json.encode(data.toMap());

class CreateOrder {
  CreateOrder({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  bool error;
  bool success;
  String message;
  Data data;

  factory CreateOrder.fromMap(Map<String, dynamic> json) => CreateOrder(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "success": success,
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  Data({
    required this.amount,
    required this.deliveryAmount,
    required this.deliveryTime,
    required this.promoAmount,
    required this.addressId,
    required this.walletAmount,
    required this.referral,
  });

  String amount;
  double deliveryAmount;
  String deliveryTime;
  String promoAmount;
  int addressId;
  int walletAmount;
  Referral referral;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        amount: json["amount"],
        deliveryAmount: json["delivery_amount"].toDouble(),
        deliveryTime: json["delivery_time"],
        promoAmount: json["promo_amount"],
        addressId: json["address_id"],
        walletAmount: json["wallet_amount"],
        referral: Referral.fromMap(json["referral"]),
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "delivery_amount": deliveryAmount,
        "delivery_time": deliveryTime,
        "promo_amount": promoAmount,
        "address_id": addressId,
        "wallet_amount": walletAmount,
        "referral": referral.toMap(),
      };
}

class Referral {
  Referral({
    required this.result,
  });

  Result result;

  factory Referral.fromMap(Map<String, dynamic> json) => Referral(
        result: Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "result": result.toMap(),
      };
}

class Result {
  Result({
    required this.id,
    required this.userId,
    required this.referralCode,
    required this.referredBy,
    required this.isFirstOrder,
    required this.createdDtm,
  });

  int id;
  int userId;
  String referralCode;
  int referredBy;
  int isFirstOrder;
  DateTime createdDtm;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        referralCode: json["referral_code"],
        referredBy: json["referred_by"],
        isFirstOrder: json["is_first_order"],
        createdDtm: DateTime.parse(json["createdDtm"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "referral_code": referralCode,
        "referred_by": referredBy,
        "is_first_order": isFirstOrder,
        "createdDtm": createdDtm.toIso8601String(),
      };
}
