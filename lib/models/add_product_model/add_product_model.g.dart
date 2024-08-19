// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductModel _$AddProductModelFromJson(Map<String, dynamic> json) =>
    AddProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      inStock: (json['inStock'] as num).toInt(),
      colors: (json['colors'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProductColorEnumMap, e))
          .toList(),
      sizes: (json['sizes'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProductSizeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$AddProductModelToJson(AddProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'inStock': instance.inStock,
      'colors': instance.colors.map((e) => _$ProductColorEnumMap[e]!).toList(),
      'sizes': instance.sizes.map((e) => _$ProductSizeEnumMap[e]!).toList(),
    };

const _$ProductColorEnumMap = {
  ProductColor.red: 'red',
  ProductColor.blue: 'blue',
  ProductColor.green: 'green',
};

const _$ProductSizeEnumMap = {
  ProductSize.S: 'S',
  ProductSize.M: 'M',
  ProductSize.L: 'L',
  ProductSize.XL: 'XL',
};
