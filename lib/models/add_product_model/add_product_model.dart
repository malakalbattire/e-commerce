import 'package:json_annotation/json_annotation.dart';

part 'add_product_model.g.dart';

enum ProductColor {
  red,
  blue,
  green,
  defaultColor,
}

enum ProductSize {
  S,
  M,
  L,
  XL,
  OneSize,
}

@JsonSerializable()
class AddProductModel {
  String id;
  String name;
  String imgUrl;
  double price;
  String description;
  String category;
  int inStock;
  // List<ProductColor> colors;
  // List<ProductSize> sizes;

  AddProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.inStock,
    // required this.colors,
    // required this.sizes,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddProductModelToJson(this);

  AddProductModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    double? price,
    String? description,
    String? category,
    int? inStock,
    // List<ProductColor>? colors,
    // List<ProductSize>? sizes,
  }) {
    return AddProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      inStock: inStock ?? this.inStock,
      // colors: colors ?? this.colors,
      // sizes: sizes ?? this.sizes,
    );
  }

  factory AddProductModel.fromMap(Map<String, dynamic> map) {
    return AddProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imgUrl: map['imgUrl'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      inStock: map['inStock'] as int,
      // colors: List<ProductColor>.from(
      //   (map['colors'] as List<dynamic>).map(
      //     (e) => ProductColor.values.firstWhere(
      //       (color) => color.name == e as String,
      //     ),
      //   ),
      // ),
      // sizes: List<ProductSize>.from(
      //   (map['sizes'] as List<dynamic>).map(
      //     (e) => ProductSize.values.firstWhere(
      //       (size) => size.name == e as String,
      //     ),
      //   ),
      // ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'price': price,
      'description': description,
      'category': category,
      'inStock': inStock,
      // 'colors': colors.map((color) => color.name).toList(),
      // 'sizes': sizes.map((size) => size.name).toList(),
    };
  }
}
