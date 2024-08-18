// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutModel _$CheckoutModelFromJson(Map<String, dynamic> json) =>
    CheckoutModel(
      userId: json['userId'] as String,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      addressIds: (json['addressIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      paymentIds: (json['paymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String,
      orderNumber: (json['orderNumber'] as num).toInt(),
    );

Map<String, dynamic> _$CheckoutModelToJson(CheckoutModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'productIds': instance.productIds,
      'addressIds': instance.addressIds,
      'paymentIds': instance.paymentIds,
      'totalAmount': instance.totalAmount,
      'orderStatus': instance.orderStatus,
      'orderNumber': instance.orderNumber,
    };
