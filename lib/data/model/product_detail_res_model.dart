// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailResModel productDetailModelFromJson(String str) =>
    ProductDetailResModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailResModel data) =>
    json.encode(data.toJson());

class ProductDetailResModel {
  ProductDetailResModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ProductData data;

  factory ProductDetailResModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailResModel(
        success: json["success"],
        message: json["message"],
        data: ProductData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ProductData {
  ProductData({
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
    required this.createdDtm,
    required this.productImg,
    required this.categoryName,
    required this.storeImage,
    required this.storeName,
    required this.storeDesc,
    required this.discount,
    this.cartQuantity,
  });

  final int id;
  final String name;
  final String description;
  final int price;
  final int categoryId;
  final int stock;
  final int isPopular;
  final int isAlcohol;
  final int isDeleted;
  final int? warehouseId;
  final DateTime createdDtm;
  final String productImg;
  final String categoryName;
  final String storeImage;
  final String storeName;
  final String storeDesc;
  final int discount;
  int? cartQuantity = 0;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        categoryId: json["category_id"],
        stock: json["stock"],
        isPopular: json["isPopular"],
        isAlcohol: json["isAlcohol"],
        isDeleted: json["isDeleted"],
        warehouseId: json["warehouse_id"],
        createdDtm: DateTime.parse(json["createdDtm"]),
        productImg: json["product_img"],
        categoryName: json["category_name"],
        storeImage: json["store_img"],
    storeName: json["store_name"],
    storeDesc: json["store_desc"],
    discount: json["discount"],
        cartQuantity:
            json.containsKey('cart_quantity') ? json["cart_quantity"] : 0,
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
        "createdDtm": createdDtm.toIso8601String(),
        "product_img": productImg,
        "category_name": categoryName,
        "cart_quantity": cartQuantity,
      };
}
