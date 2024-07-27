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
    );

Map<String, dynamic> _$AddToCartModelToJson(AddToCartModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product.toJson(),
      'size': _$SizeEnumMap[instance.size]!,
      'quantity': instance.quantity,
    };

const _$SizeEnumMap = {
  Size.S: 'S',
  Size.M: 'M',
  Size.L: 'L',
  Size.xL: 'xL',
};
