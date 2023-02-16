// To parse this JSON data, do
//
//     final liveOrderTrackingResModel = liveOrderTrackingResModelFromJson(jsonString);

import 'dart:convert';

LiveOrderTrackingResModel liveOrderTrackingResModelFromJson(String str) =>
    LiveOrderTrackingResModel.fromJson(json.decode(str));

String liveOrderTrackingResModelToJson(LiveOrderTrackingResModel data) =>
    json.encode(data.toJson());

class LiveOrderTrackingResModel {
  LiveOrderTrackingResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory LiveOrderTrackingResModel.fromJson(Map<String, dynamic> json) =>
      LiveOrderTrackingResModel(
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
    required this.status,
    required this.deliveryTime,
    required this.deliveryAddress,
    required this.orderTime,
    required this.driverName,
    required this.driverImg,
    required this.driverMobile,
    required this.driverLatitude,
    required this.driverLongitude,
  });

  String status;
  String deliveryTime;
  DeliveryAddress deliveryAddress;
  DateTime orderTime;
  String driverName;
  String driverImg;
  String driverMobile;
  String driverLatitude;
  String driverLongitude;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        deliveryTime: json["delivery_time"],
        deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
        orderTime: DateTime.parse(json["order_time"]),
        driverName: json["driver_name"],
        driverImg: json["driver_img"],
        driverMobile: json["driver_mobile"],
        driverLatitude: json["driver_latitude"],
        driverLongitude: json["driver_longitude"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "delivery_time": deliveryTime,
        "delivery_address": deliveryAddress.toJson(),
        "order_time": orderTime.toIso8601String(),
        "driver_name": driverName,
        "driver_img": driverImg,
        "driver_mobile": driverMobile,
        "driver_latitude": driverLatitude,
        "driver_longitude": driverLongitude,
      };
}

class DeliveryAddress {
  DeliveryAddress({
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

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
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
