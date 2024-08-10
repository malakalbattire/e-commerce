import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String userId;
  final List<String> productIds;
  final String cityName;
  final String addressId;
  final String paymentId;
  final String countryName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String cardNumber;
  final double totalAmount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.productIds,
    required this.cityName,
    required this.addressId,
    required this.paymentId,
    required this.countryName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.cardNumber,
    required this.totalAmount,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel copyWith({
    String? id,
    String? userId,
    List<String>? productIds,
    String? cityName,
    String? addressId,
    String? paymentId,
    String? countryName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? cardNumber,
    double? totalAmount,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productIds: productIds ?? this.productIds,
      cityName: cityName ?? this.cityName,
      addressId: addressId ?? this.addressId,
      paymentId: paymentId ?? this.paymentId,
      countryName: countryName ?? this.countryName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productIds: List<String>.from(map['productIds'] as List<dynamic>),
      cityName: map['cityName'] as String,
      addressId: map['addressId'] as String,
      paymentId: map['paymentId'] as String,
      countryName: map['countryName'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      cardNumber: map['cardNumber'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productIds': productIds,
      'cityName': cityName,
      'addressId': addressId,
      'paymentId': paymentId,
      'countryName': countryName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'cardNumber': cardNumber,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
    };
  }
}
