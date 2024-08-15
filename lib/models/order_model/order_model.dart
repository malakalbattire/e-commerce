import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/order_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;
  String userId;
  final List<OrderItem> items;
  final String cityName;
  final List<String> productIds;
  final String addressId;
  final String paymentId;
  final String countryName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String cardNumber;
  final double totalAmount;
  final DateTime createdAt;
  final int orderNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.cityName,
    required this.productIds,
    required this.addressId,
    required this.paymentId,
    required this.countryName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.cardNumber,
    required this.totalAmount,
    required this.createdAt,
    required this.orderNumber,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    String? cityName,
    List<String>? productIds,
    String? addressId,
    String? paymentId,
    String? countryName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? cardNumber,
    double? totalAmount,
    DateTime? createdAt,
    int? orderNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      cityName: cityName ?? this.cityName,
      productIds: productIds ?? this.productIds,
      addressId: addressId ?? this.addressId,
      paymentId: paymentId ?? this.paymentId,
      countryName: countryName ?? this.countryName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      cityName: map['cityName'] as String,
      productIds: List<String>.from(map['productIds'] as List<dynamic>),
      addressId: map['addressId'] as String,
      paymentId: map['paymentId'] as String,
      countryName: map['countryName'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      cardNumber: map['cardNumber'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      orderNumber: map['orderNumber'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'cityName': cityName,
      'productIds': productIds,
      'addressId': addressId,
      'paymentId': paymentId,
      'countryName': countryName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'cardNumber': cardNumber,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'orderNumber': orderNumber,
    };
  }
}
