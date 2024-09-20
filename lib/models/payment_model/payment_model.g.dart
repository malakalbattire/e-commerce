// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      cvvCode: json['cvvCode'] as String,
      userId: json['userId'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardNumber': instance.cardNumber,
      'expiryDate': instance.expiryDate,
      'cvvCode': instance.cvvCode,
      'isSelected': instance.isSelected,
      'userId': instance.userId,
    };
