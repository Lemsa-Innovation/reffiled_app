// To parse this JSON data, do
//
//     final ordersResModel = ordersResModelFromJson(jsonString);

import 'dart:convert';

OrdersResModel ordersResModelFromJson(String str) =>
    OrdersResModel.fromJson(json.decode(str));

String ordersResModelToJson(OrdersResModel data) => json.encode(data.toJson());

class OrdersResModel {
  OrdersResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Order> data;

  factory OrdersResModel.fromJson(Map<String, dynamic> json) => OrdersResModel(
        success: json["success"],
        message: json["message"],
        data: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Order {
  Order({
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
  });

  int id;
  int userId;
  List<OrderDetail> orderDetails;
  String promoAmount;
  String deliveryTime;
  String deliveryAmount;
  String totalAmount;
  Address address;
  String status;
  int driverId;
  DateTime createdDtm;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        userId: json["user_id"],
        orderDetails: List<OrderDetail>.from(
            json["order_details"].map((x) => OrderDetail.fromJson(x))),
        promoAmount: json["promo_amount"],
        deliveryTime: json["delivery_time"],
        deliveryAmount: json["delivery_amount"],
        totalAmount: json["total_amount"],
        address: Address.fromJson(json["address"]),
        status: json["status"],
        driverId: json["driver_id"],
        createdDtm: DateTime.parse(json["createdDtm"]),
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

class OrderDetail {
  OrderDetail({
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

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
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
