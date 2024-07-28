import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final String id;
  final String productId;
  final String userId;

  FavoriteModel({
    required this.id,
    required this.productId,
    required this.userId,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  factory FavoriteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FavoriteModel(
      id: documentId,
      productId: map['productId'] as String,
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? productId,
    String? userId,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
    );
  }
}
