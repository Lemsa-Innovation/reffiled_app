// To parse this JSON data, do
//
//     final trackOrderResModel = trackOrderResModelFromJson(jsonString);

import 'dart:convert';

TrackOrderResModel trackOrderResModelFromJson(String str) =>
    TrackOrderResModel.fromJson(json.decode(str));

String trackOrderResModelToJson(TrackOrderResModel data) =>
    json.encode(data.toJson());

class TrackOrderResModel {
  TrackOrderResModel({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  bool error;
  bool success;
  String message;
  Data data;

  factory TrackOrderResModel.fromJson(Map<String, dynamic> json) =>
      TrackOrderResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.status,
    required this.deliveryTime,
    required this.orderTime,
    required this.deliveryAddress,
    required this.warehouseLatitude,
    required this.warehouseLongitude,
  });

  String status;
  String deliveryTime;
  DateTime orderTime;
  DeliveryAddress deliveryAddress;
  String warehouseLatitude;
  String warehouseLongitude;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        deliveryTime: json["delivery_time"],
        orderTime: DateTime.parse(json["order_time"]),
        deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
        warehouseLatitude: json["warehouse_latitude"],
        warehouseLongitude: json["warehouse_longitude"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "delivery_time": deliveryTime,
        "order_time": orderTime.toIso8601String(),
        "delivery_address": deliveryAddress.toJson(),
        "warehouse_latitude": warehouseLatitude,
        "warehouse_longitude": warehouseLongitude,
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
