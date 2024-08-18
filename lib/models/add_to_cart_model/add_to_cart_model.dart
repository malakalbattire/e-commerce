import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final Size size;
  int quantity;
  final double price;
  final String imgUrl;
  final String name;
  final int inStock;
  final String color;

  AddToCartModel({
    required this.id,
    required this.product,
    required this.size,
    required this.quantity,
    required this.price,
    required this.imgUrl,
    required this.name,
    required this.inStock,
    required this.color,
  });

  double get totalPrice => price * quantity;

  AddToCartModel copyWith({
    String? id,
    ProductItemModel? product,
    Size? size,
    int? quantity,
    double? price,
    String? imgUrl,
    String? name,
    int? inStock,
    String? color,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      inStock: inStock ?? this.inStock,
      color: color ?? this.color,
    );
  }

  factory AddToCartModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartModelToJson(this);

  factory AddToCartModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AddToCartModel(
      id: documentId,
      product:
          ProductItemModel.fromJson(map['product'] as Map<String, dynamic>),
      size: _sizeFromString(map['size'] as String),
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      imgUrl: map['imgUrl'] as String,
      name: map['name'] as String,
      inStock: map['inStock'] as int,
      color: map['color'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toJson(),
      'size': _sizeToString(size),
      'quantity': quantity,
      'price': price,
      'imgUrl': imgUrl,
      'name': name,
      'inStock': inStock,
      'color': color,
    };
  }

  static Size _sizeFromString(String size) {
    switch (size) {
      case 'S':
        return Size.S;
      case 'M':
        return Size.M;
      case 'L':
        return Size.L;
      case 'XL':
        return Size.xL;
      case 'OneSize':
        return Size.OneSize;
      default:
        throw ArgumentError('Invalid size string');
    }
  }

  static String _sizeToString(Size size) {
    switch (size) {
      case Size.S:
        return 'S';
      case Size.M:
        return 'M';
      case Size.L:
        return 'L';
      case Size.xL:
        return 'XL';
      case Size.OneSize:
        return 'OneSize';
      default:
        throw ArgumentError('Invalid size');
    }
  }
}

enum Size { S, M, L, xL, OneSize }
