import 'package:json_annotation/json_annotation.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel {
  final String id;
  final String cardNumber;
  final String expiryDate;
  final String cvvCode;
  final String imgUrl;
  final String name;
  final bool isSelected;
  final String userId;

  PaymentMethodModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvvCode,
    required this.userId,
    this.imgUrl =
        'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
    this.name = 'Master Card',
    this.isSelected = false,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvvCode,
    String? imgUrl,
    String? name,
    bool? isSelected,
    String? userId,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvvCode: cvvCode ?? this.cvvCode,
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      userId: userId ?? this.userId,
    );
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvvCode: map['cvvCode'] ?? '',
      imgUrl: map['imgUrl'] ??
          'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
      name: map['name'] ?? 'Master Card',
      isSelected: map['isSelected'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvvCode': cvvCode,
      'imgUrl': imgUrl,
      'name': name,
      'isSelected': isSelected,
      'userId': userId,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}
//
// CREATE TABLE cards (
// id VARCHAR(255) NOT NULL PRIMARY KEY, -- Unique identifier for each card
// cardNumber VARCHAR(16) NOT NULL,      -- Card number (assuming it's a 16-digit number)
// cardHolderName VARCHAR(255) NOT NULL, -- Name of the cardholder
// expiryDate VARCHAR(7) NOT NULL,       -- Expiry date in MM/YYYY format
// cvvCode VARCHAR(4) NOT NULL,          -- CVV code (assuming it is 3-4 digits)
// imgUrl VARCHAR(512) DEFAULT 'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg', -- URL to image with default
// name VARCHAR(255) DEFAULT 'Master Card', -- Default card name
// isSelected BOOLEAN DEFAULT FALSE,     -- Indicates if the card is selected (default false)
// userId VARCHAR(255) NOT NULL,         -- Reference to the user who owns this card
// FOREIGN KEY (userId) REFERENCES users(id) -- Assuming a `users` table exists with `id` as the primary key
// );
