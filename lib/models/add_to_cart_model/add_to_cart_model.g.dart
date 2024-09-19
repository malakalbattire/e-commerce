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
      inStock: (json['inStock'] as num).toInt(),
      color: json['color'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
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
      'inStock': instance.inStock,
      'color': instance.color,
      'productId': instance.productId,
      'userId': instance.userId,
    };

const _$SizeEnumMap = {
  Size.S: 'S',
  Size.M: 'M',
  Size.L: 'L',
  Size.xL: 'xL',
  Size.OneSize: 'OneSize',
};
