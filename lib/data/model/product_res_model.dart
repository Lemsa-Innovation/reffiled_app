// To parse this JSON data, do
//
//     final productResModel = productResModelFromJson(jsonString);

import 'dart:convert';

ProductResModel productResModelFromJson(String str) =>
    ProductResModel.fromJson(json.decode(str));

String productResModelToJson(ProductResModel data) =>
    json.encode(data.toJson());

class ProductResModel {
  ProductResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<Product> data;

  factory ProductResModel.fromJson(Map<String, dynamic> json){
    List<Product> data = [];

    data.addAll(json["data"] == null || json['data'].isEmpty
        ? []
        : json["data"]["popular"] == null || json["data"]["popular"].isEmpty ? [] : List<Product>.from(json["data"]["popular"].map((x) => Product.fromJson(x))));

    data.addAll(json["data"] == null || json['data'].isEmpty
        ? []
        : json["data"]["noPopular"] == null || json["data"]["noPopular"].isEmpty ? [] : List<Product>.from(json["data"]["noPopular"].map((x) => Product.fromJson(x))));


    // data = json["data"] == null || json['data'].isEmpty
    //     ? []
    //     : json["data"]["popular"] == null || json["data"]["noPopular"].isEmpty ? [] : List<Product>.from(json["data"]["popular"].map((x) => Product.fromJson(x)));

    return  ProductResModel(
      success: json["success"],
      message: json["message"],
      data: data
    );

  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.stock,
    required this.isPopular,
    required this.isAlcohol,
    required this.isDeleted,
    required this.warehouseId,
    required this.productImg,
    required this.discount,
  });

  final int id;
  final String name;
  final String description;
  final int price;
  final int discount;
  final int categoryId;
  final int stock;
  final int isPopular;
  final int isAlcohol;
  final int isDeleted;
  final int warehouseId;
  final String productImg;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"] == null ? '' : json['name'],
        description: json["description"] ?? '',
        price: json["price"],
        categoryId: json["category_id"],
        stock: json["stock"],
        isPopular: json["isPopular"],
        isAlcohol: json["isAlcohol"],
        isDeleted: json["isDeleted"],
        warehouseId: json["warehouse_id"] ?? 0,
        productImg: json["product_img"],
    discount: json["discount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "stock": stock,
        "isPopular": isPopular,
        "isAlcohol": isAlcohol,
        "isDeleted": isDeleted,
        "warehouse_id": warehouseId,
        "product_img": productImg,
      };
}
