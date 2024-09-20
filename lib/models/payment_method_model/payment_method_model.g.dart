// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      cvvCode: json['cvvCode'] as String,
      userId: json['userId'] as String,
      imgUrl: json['imgUrl'] as String? ??
          'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
      name: json['name'] as String? ?? 'Master Card',
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardNumber': instance.cardNumber,
      'expiryDate': instance.expiryDate,
      'cvvCode': instance.cvvCode,
      'imgUrl': instance.imgUrl,
      'name': instance.name,
      'isSelected': instance.isSelected,
      'userId': instance.userId,
    };
