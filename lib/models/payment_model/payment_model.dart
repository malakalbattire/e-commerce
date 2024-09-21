import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  final String id;
  final String cardNumber;
  final String expiryDate;
  final String cvvCode;
  final bool isSelected;
  final String userId;

  PaymentModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvvCode,
    required this.userId,
    this.isSelected = false,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  factory PaymentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PaymentModel(
      id: documentId,
      cardNumber: map['cardNumber'] as String? ?? '',
      expiryDate: map['expiryDate'] as String? ?? '',
      cvvCode: map['cvvCode'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      isSelected: (map['isSelected'] is bool)
          ? map['isSelected'] as bool
          : (map['isSelected'] == 1),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvvCode': cvvCode,
      'isSelected': isSelected ? 1 : 0,
      'userId': userId,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? cardNumber,
    String? expiryDate,
    String? cvvCode,
    bool? isSelected,
    String? userId,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvvCode: cvvCode ?? this.cvvCode,
      userId: userId ?? this.userId,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
