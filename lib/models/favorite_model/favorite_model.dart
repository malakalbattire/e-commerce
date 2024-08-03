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

  FavoriteModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.isFavorite,
    required this.description,
    required this.price,
    required this.category,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  factory FavoriteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FavoriteModel(
      id: documentId,
      name: map['name'] as String,
      imgUrl: map['imgUrl'] as String,
      isFavorite: map['isFavorite'] as bool,
      description: map['description'] as String,
      price: map['price'] as double,
      category: map['category'] as String,
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
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }
}
