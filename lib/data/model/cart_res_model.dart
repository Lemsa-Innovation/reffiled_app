// To parse this JSON data, do
//
//     final cartResModel = cartResModelFromJson(jsonString);

import 'dart:convert';

CartResModel cartResModelFromJson(String str) =>
    CartResModel.fromJson(json.decode(str));

String cartResModelToJson(CartResModel data) => json.encode(data.toJson());

class CartResModel {
  CartResModel({
    required this.success,
    required this.message,
    required this.data,
    required this.subtotal,
    required this.tax,
    required this.wallet,
    required this.driverBenefitsFee,
    required this.stateTaxRate,

  });

  bool success;
  String message;
  List<CartItem> data;
  int subtotal;
  double tax;
  double wallet;
  double driverBenefitsFee;
  double stateTaxRate;

  factory CartResModel.fromJson(Map<String, dynamic> json) => CartResModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null || json["data"].isEmpty
            ? []
            : List<CartItem>.from(
                json["data"].map((x) => CartItem.fromJson(x))),
        subtotal: json["subtotal"] ?? 0,
        tax: (json["tax"])?.toDouble() ?? 0,
    wallet: double.parse(json['wallet'].toString()),
    driverBenefitsFee: json['driver_benefits_fee'],
    stateTaxRate: json['state_tax_rate'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "subtotal": subtotal,
        "tax": tax,
      };
}

class CartItem {
  CartItem({
    required this.productId,
    required this.productName,
    required this.productDesc,
    required this.productImg,
    required this.price,
    required this.isAlcohol,
    required this.quantity,
    required this.stock,
  });

  int productId;
  String productName;
  String productDesc;
  String productImg;
  int price;
  int isAlcohol;
  int quantity;
  int stock;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json["id"],
        productName: json["name"],
        productDesc: json["description"],
        productImg: json["product_img"],
        price: json["price"],
        isAlcohol: json["isAlcohol"],
        quantity: json["quantity"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_desc": productDesc,
        "product_img": productImg,
        "price": price,
        "isAlcohol": isAlcohol,
        "quantity": quantity,
        "stock": stock,
      };
}
