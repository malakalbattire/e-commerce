// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartModel _$AddToCartModelFromJson(Map<String, dynamic> json) =>
    AddToCartModel(
      id: json['id'] as String,
      product:
          ProductItemModel.fromJson(json['product'] as Map<String, dynamic>),
      size: $enumDecode(_$SizeEnumMap, json['size']),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      imgUrl: json['imgUrl'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$AddToCartModelToJson(AddToCartModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product.toJson(),
      'size': _$SizeEnumMap[instance.size]!,
      'quantity': instance.quantity,
      'price': instance.price,
      'imgUrl': instance.imgUrl,
      'name': instance.name,
    };

const _$SizeEnumMap = {
  Size.S: 'S',
  Size.M: 'M',
  Size.L: 'L',
  Size.xL: 'xL',
};
