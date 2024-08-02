// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutModel _$CheckoutModelFromJson(Map<String, dynamic> json) =>
    CheckoutModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      addressId: json['addressId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$CheckoutModelToJson(CheckoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'addressId': instance.addressId,
      'paymentMethodId': instance.paymentMethodId,
      'productIds': instance.productIds,
      'totalAmount': instance.totalAmount,
    };
