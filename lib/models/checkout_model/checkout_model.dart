import 'package:json_annotation/json_annotation.dart';

part 'checkout_model.g.dart';

@JsonSerializable()
class CheckoutModel {
  final String userId;
  final List<String> productIds;
  final List<String> addressIds;
  final List<String> paymentIds;
  final double totalAmount;
  final String orderStatus;
  final int orderNumber;

  CheckoutModel({
    required this.userId,
    required this.productIds,
    required this.addressIds,
    required this.paymentIds,
    required this.totalAmount,
    required this.orderStatus,
    required this.orderNumber,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutModelToJson(this);

  factory CheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckoutModel(
      userId: map['userId'] as String,
      productIds: List<String>.from(map['productIds'] as List),
      addressIds: List<String>.from(map['addressIds'] as List),
      paymentIds: List<String>.from(map['paymentIds'] as List),
      totalAmount: map['totalAmount'] as double,
      orderStatus: map['orderStatus'] as String,
      orderNumber: map['orderNumber'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productIds': productIds,
      'addressIds': addressIds,
      'paymentIds': paymentIds,
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      'orderNumber': orderNumber,
    };
  }
}
