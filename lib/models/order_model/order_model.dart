import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String userId;
  final List<String> productIds;
  final String addressId;
  final String paymentId;
  final double totalAmount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.productIds,
    required this.addressId,
    required this.paymentId,
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
    String? addressId,
    String? paymentId,
    double? totalAmount,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productIds: productIds ?? this.productIds,
      addressId: addressId ?? this.addressId,
      paymentId: paymentId ?? this.paymentId,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productIds: List<String>.from(map['productIds'] as List<dynamic>),
      addressId: map['addressId'] as String,
      paymentId: map['paymentId'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productIds': productIds,
      'addressId': addressId,
      'paymentId': paymentId,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
    };
  }
}
