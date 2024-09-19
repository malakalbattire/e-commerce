// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      isFavorite: json['isFavorite'] as bool,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'isFavorite': instance.isFavorite,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'productId': instance.productId,
      'userId': instance.userId,
    };
