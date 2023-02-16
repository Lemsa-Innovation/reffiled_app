// To parse this JSON data, do
//
//     final productCategoryResModel = productCategoryResModelFromJson(jsonString);

import 'dart:convert';

ProductCategoryResModel productCategoryResModelFromJson(String str) =>
    ProductCategoryResModel.fromJson(json.decode(str));

String productCategoryResModelToJson(ProductCategoryResModel data) =>
    json.encode(data.toJson());

class ProductCategoryResModel {
  ProductCategoryResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<Category> data;

  factory ProductCategoryResModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryResModel(
        success: json["success"],
        message: json["message"],
        data: json['data'] != null && json['data'].isNotEmpty
            ? List<Category>.from(json["data"].map((x) => Category.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Category {
  Category(
      {required this.id,
      required this.name,
      required this.categoryImg,
      required this.isDeleted,
      required this.warehouseId,
      this.isSelected = false});

  final int? id;
  final String? name;
  final String? categoryImg;
  final int? isDeleted;
  final int? warehouseId;
  bool isSelected;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        categoryImg: json["category_img"],
        isDeleted: json["isDeleted"],
        warehouseId: json["warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_img": categoryImg,
        "isDeleted": isDeleted,
        "warehouse_id": warehouseId,
      };
}
