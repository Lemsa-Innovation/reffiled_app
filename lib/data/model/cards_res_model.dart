// To parse this JSON data, do
//
//     final cardsResModel = cardsResModelFromJson(jsonString);

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'dart:convert';

CardsResModel cardsResModelFromJson(String str) =>
    CardsResModel.fromJson(json.decode(str));

String cardsResModelToJson(CardsResModel data) => json.encode(data.toJson());

class CardsResModel {
  CardsResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<MyCard> data;

  factory CardsResModel.fromJson(Map<String, dynamic> json) => CardsResModel(
        success: json["success"],
        message: json["message"],
        data: List<MyCard>.from(json["data"].map((x) => MyCard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MyCard {
  MyCard({
    required this.id,
    required this.userId,
    required this.cardHolderName,
    required this.cardNumber,
    required this.validUpto,
    required this.createdDtm,
  });

  int id;
  int userId;
  String cardHolderName;
  String cardNumber;
  String validUpto;
  DateTime createdDtm;
  var isSelected = false.obs;

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
        id: json["id"],
        userId: json["user_id"],
        cardHolderName: json["card_holder_name"],
        cardNumber: json["card_number"],
        validUpto: json["valid_upto"],
        createdDtm: DateTime.parse(json["createdDtm"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "card_holder_name": cardHolderName,
        "card_number": cardNumber,
        "valid_upto": validUpto,
        "createdDtm": createdDtm.toIso8601String(),
      };
}
