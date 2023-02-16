// To parse this JSON data, do
//
//     final pastOrderDetailResModel = pastOrderDetailResModelFromJson(jsonString);

import 'dart:convert';

PastOrderDetailResModel pastOrderDetailResModelFromJson(String str) =>
    PastOrderDetailResModel.fromJson(json.decode(str));

String pastOrderDetailResModelToJson(PastOrderDetailResModel data) =>
    json.encode(data.toJson());

class PastOrderDetailResModel {
  PastOrderDetailResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory PastOrderDetailResModel.fromJson(Map<String, dynamic> json) =>
      PastOrderDetailResModel(
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
    required this.id,
    required this.userId,
    required this.orderDetails,
    required this.promoAmount,
    required this.deliveryTime,
    required this.deliveryAmount,
    required this.totalAmount,
    required this.address,
    required this.status,
    required this.driverId,
    required this.createdDtm,
    required this.paymentType,
    required this.invoice,
    required this.cardNumber,
    required this.tax,
    required this.orderStatus,
    required this.subtotal,
  });

  int id;
  int userId;
  List<OrderedProduct> orderDetails;
  String promoAmount;
  String deliveryTime;
  String deliveryAmount;
  String totalAmount;
  Address address;
  String status;
  int driverId;
  DateTime createdDtm;
  String paymentType;
  String invoice;
  String cardNumber;
  num tax;
  String orderStatus;
  num subtotal;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        orderDetails: List<OrderedProduct>.from(
            json["order_details"].map((x) => OrderedProduct.fromJson(x))),
        promoAmount: json["promo_amount"],
        deliveryTime: json["delivery_time"],
        deliveryAmount: json["delivery_amount"],
        totalAmount: json["total_amount"],
        address: Address.fromJson(json["address"]),
        status: json["status"],
        driverId: json["driver_id"],
        createdDtm: DateTime.parse(json["createdDtm"]),
        paymentType: json["payment_type"],
        invoice: json["invoice"],
        cardNumber: json["card_number"],
        tax: json["tax"],
        orderStatus: json['status'],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_details":
            List<dynamic>.from(orderDetails.map((x) => x.toJson())),
        "promo_amount": promoAmount,
        "delivery_time": deliveryTime,
        "delivery_amount": deliveryAmount,
        "total_amount": totalAmount,
        "address": address.toJson(),
        "status": status,
        "driver_id": driverId,
        "createdDtm": createdDtm.toIso8601String(),
        "payment_type": paymentType,
        "invoice": invoice,
        "card_number": cardNumber,
        "tax": tax,
        "order_status": orderStatus,
        "subtotal": subtotal,
      };
}

class Address {
  Address({
    required this.addressTag,
    required this.address,
    required this.aditionalAddress,
    required this.latitude,
    required this.longitude,
  });

  String addressTag;
  String address;
  String aditionalAddress;
  String latitude;
  String longitude;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressTag: json["addressTag"],
        address: json["address"],
        aditionalAddress: json["aditionalAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "addressTag": addressTag,
        "address": address,
        "aditionalAddress": aditionalAddress,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class OrderedProduct {
  OrderedProduct({
    required this.productId,
    required this.productName,
    required this.productDesc,
    required this.productImg,
    required this.price,
    required this.isAlcohol,
    required this.quantity,
  });

  int productId;
  String productName;
  String productDesc;
  String productImg;
  int price;
  int isAlcohol;
  int quantity;

  factory OrderedProduct.fromJson(Map<String, dynamic> json) => OrderedProduct(
        productId: json["product_id"],
        productName: json["product_name"],
        productDesc: json["product_desc"],
        productImg: json["product_img"],
        price: json["price"],
        isAlcohol: json["isAlcohol"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_desc": productDesc,
        "product_img": productImg,
        "price": price,
        "isAlcohol": isAlcohol,
        "quantity": quantity,
      };
}
