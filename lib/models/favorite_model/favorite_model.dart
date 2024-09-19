
import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final String id;
  final String name;
  final String imgUrl;
  final bool isFavorite;
  final String description;
  final double price;
  final String category;
  final String productId;
  final String userId;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.isFavorite,
    required this.description,
    required this.price,
    required this.category,
    required this.productId,
    required this.userId,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imgUrl: json['imgUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  factory FavoriteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FavoriteModel(
      id: documentId,
      name: map['name'] as String? ?? '',
      imgUrl: map['imgUrl'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] as String? ?? '',
      productId: map['product_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'isFavorite': isFavorite,
      'description': description,
      'price': price,
      'category': category,
      'product_id': productId,
      'user_id': userId,
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    bool? isFavorite,
    String? description,
    double? price,
    String? category,
    String? productId,
    String? userId,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
    );
  }
}
