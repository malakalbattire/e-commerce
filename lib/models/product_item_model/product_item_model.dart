import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'product_item_model.g.dart';

enum ProductSize { S, M, L, xL }

enum ProductColor {
  Red('#FF0000'),
  Blue('#0000FF'),
  Green('#00FF00'),
  Black('#000000'),
  White('#FFFFFF');

  final String hexCode;

  const ProductColor(this.hexCode);

  Color get color => Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
}

@JsonSerializable()
class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final bool isFavorite;
  final String description;
  final double price;
  final String category;
  final int quantity;
  final List<ProductSize>?
      sizes; // Changed from ProductSize? to List<ProductSize>?
  final bool isAddedToCart;
  final double averageRate;
  final int inStock;
  final List<ProductColor>? colors;

  const ProductItemModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.isFavorite = false,
    this.description = 'description lorem hello you one of two ',
    required this.price,
    required this.category,
    this.quantity = 0,
    this.sizes, // Updated here
    this.isAddedToCart = false,
    this.averageRate = 0.0,
    this.inStock = 0,
    this.colors,
  });

  @override
  String toString() {
    return 'ProductItemModel{id:$id,name:$name,imgUrl: $imgUrl,isFavorite:$isFavorite,inStock:$inStock,description:$description,price:$price,category:$category,quantity:$quantity,sizes:$sizes,isAddedToCart:$isAddedToCart, colors:$colors}';
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductItemModelToJson(this);

  factory ProductItemModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return ProductItemModel(
      id: documentId,
      name: data['name'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      quantity: data['quantity']?.toInt() ?? 0,
      averageRate: data['averageRate']?.toDouble() ?? 0.0,
      sizes: data['sizes'] != null
          ? List<ProductSize>.from((data['sizes'] as List).map(
              (e) => ProductSize.values.firstWhere((size) => size.name == e)))
          : null,
      isAddedToCart: data['isAddedToCart'] ?? false,
      inStock: data['inStock']?.toInt() ?? 0,
      colors: data['colors'] != null
          ? List<ProductColor>.from((data['colors'] as List).map((e) =>
              ProductColor.values.firstWhere((color) => color.name == e)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'isFavorite': isFavorite,
      'description': description,
      'price': price,
      'category': category,
      'quantity': quantity,
      'sizes': sizes?.map((size) => size.name).toList(), // Updated here
      'isAddedToCart': isAddedToCart,
      'inStock': inStock,
      'colors': colors?.map((color) => color.name).toList(),
    };
  }

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    bool? isFavorite,
    String? description,
    double? price,
    String? category,
    int? quantity,
    List<ProductSize>? sizes, // Updated here
    bool? isAddedToCart,
    double? averageRate,
    int? inStock,
    List<ProductColor>? colors,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      sizes: sizes ?? this.sizes, // Updated here
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      averageRate: averageRate ?? this.averageRate,
      inStock: inStock ?? this.inStock,
      colors: colors ?? this.colors,
    );
  }
}
