// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItemModel _$ProductItemModelFromJson(Map<String, dynamic> json) =>
    ProductItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String? ??
          'description lorem hello you one of two ',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ProductSizeEnumMap, e))
          .toList(),
      isAddedToCart: json['isAddedToCart'] as bool? ?? false,
      averageRate: (json['averageRate'] as num?)?.toDouble() ?? 0.0,
      inStock: (json['inStock'] as num?)?.toInt() ?? 0,
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ProductColorEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$ProductItemModelToJson(ProductItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'isFavorite': instance.isFavorite,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'quantity': instance.quantity,
      'sizes': instance.sizes?.map((e) => _$ProductSizeEnumMap[e]!).toList(),
      'isAddedToCart': instance.isAddedToCart,
      'averageRate': instance.averageRate,
      'inStock': instance.inStock,
      'colors': instance.colors?.map((e) => _$ProductColorEnumMap[e]!).toList(),
    };

const _$ProductSizeEnumMap = {
  ProductSize.S: 'S',
  ProductSize.M: 'M',
  ProductSize.L: 'L',
  ProductSize.xL: 'xL',
};

const _$ProductColorEnumMap = {
  ProductColor.Red: 'Red',
  ProductColor.Blue: 'Blue',
  ProductColor.Green: 'Green',
  ProductColor.Black: 'Black',
  ProductColor.White: 'White',
};
