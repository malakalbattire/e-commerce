// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cityName: json['cityName'] as String,
      addressId: json['addressId'] as String,
      paymentId: json['paymentId'] as String,
      countryName: json['countryName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      cardNumber: json['cardNumber'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderNumber: (json['orderNumber'] as num).toInt(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'productIds': instance.productIds,
      'cityName': instance.cityName,
      'addressId': instance.addressId,
      'paymentId': instance.paymentId,
      'countryName': instance.countryName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'cardNumber': instance.cardNumber,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'orderNumber': instance.orderNumber,
    };
