import 'dart:convert';

MyAddressResModel myAddressResModelFromJson(String str) =>
    MyAddressResModel.fromJson(json.decode(str));

String myAddressResModelToJson(MyAddressResModel data) =>
    json.encode(data.toJson());

class MyAddressResModel {
  MyAddressResModel({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  bool error;
  bool success;
  String message;
  List<MyAddressData>? data;

  factory MyAddressResModel.fromJson(Map<String, dynamic> json) =>
      MyAddressResModel(
        error: json["error"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<MyAddressData>.from(
                json["data"].map((x) => MyAddressData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MyAddressData {
  MyAddressData({
    required this.id,
    required this.userId,
    required this.addressTag,
    required this.address,
    required this.aditionalAddress,
    required this.latitude,
    required this.longitude,
    required this.createdDtm,
    required this.isDeleted,
  });

  int id;
  int userId;
  String addressTag;
  String address;
  String aditionalAddress;
  String latitude;
  String longitude;
  DateTime? createdDtm;
  int isDeleted;

  factory MyAddressData.fromJson(Map<String, dynamic> json) => MyAddressData(
        id: json["id"],
        userId: json["userId"],
        addressTag: json["addressTag"],
        address: json["address"],
        aditionalAddress: json["aditionalAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdDtm: json["createdDtm"] == null
            ? null
            : DateTime.parse(json["createdDtm"]),
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "addressName": addressTag,
        "addressLine1": address,
        "addressLine2": aditionalAddress,
        "latitude": latitude,
        "longitude": longitude,
        "createdDtm": createdDtm == null ? null : createdDtm!.toIso8601String(),
        "isDeleted": isDeleted,
      };
}
