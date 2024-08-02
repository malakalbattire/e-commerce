import 'package:json_annotation/json_annotation.dart';

part 'checkout_model.g.dart';

@JsonSerializable()
class CheckoutModel {
  final String id;
  final String userId;
  final String addressId;
  final String paymentMethodId;
  final List<String> productIds;
  final double totalAmount;

  CheckoutModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.paymentMethodId,
    required this.productIds,
    required this.totalAmount,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutModelToJson(this);

  factory CheckoutModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CheckoutModel(
      id: documentId,
      userId: map['userId'] as String,
      addressId: map['addressId'] as String,
      paymentMethodId: map['paymentMethodId'] as String,
      productIds: List<String>.from(map['productIds']),
      totalAmount: map['totalAmount'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'addressId': addressId,
      'paymentMethodId': paymentMethodId,
      'productIds': productIds,
      'totalAmount': totalAmount,
    };
  }

  CheckoutModel copyWith({
    String? id,
    String? userId,
    String? addressId,
    String? paymentMethodId,
    List<String>? productIds,
    double? totalAmount,
  }) {
    return CheckoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      productIds: productIds ?? this.productIds,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
