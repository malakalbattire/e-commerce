import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_item_model.g.dart';

enum ProductSize { S, M, L, xL }

@JsonSerializable()
class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final bool isFavorite;
  final String description;
  final double price;
  final String category;
  final int quantity;
  final ProductSize? size;
  final bool isAddedToCart;
  final double averageRate;
  final int inStock;

  const ProductItemModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.isFavorite = false,
    this.description = 'description lorem hello you one of two ',
    required this.price,
    required this.category,
    this.quantity = 0,
    this.size,
    this.isAddedToCart = false,
    this.averageRate = 0.0,
    this.inStock = 0,
  });

  @override
  String toString() {
    return 'ProductItemModel{id:$id,name:$name,imgUrl: $imgUrl,isFavorite:$isFavorite,inStock:$inStock,description:$description,price:$price,category:$category,quantity:$quantity,size:$size,isAddedToCart:$isAddedToCart}';
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductItemModelToJson(this);

  factory ProductItemModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return ProductItemModel(
      id: documentId,
      name: data['name'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      quantity: data['quantity']?.toInt() ?? 0,
      averageRate: data['averageRate']?.toInt() ?? 0.0,
      size: data['size'] != null
          ? ProductSize.values.firstWhere((e) => e.name == data['size'])
          : null,
      isAddedToCart: data['isAddedToCart'] ?? false,
      inStock: data['inStock']?.toInt() ?? 0,
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
      'quantity': quantity,
      'size': size?.name,
      'isAddedToCart': isAddedToCart,
      'inStock': inStock,
    };
  }

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    bool? isFavorite,
    String? description,
    double? price,
    String? category,
    int? quantity,
    ProductSize? size,
    bool? isAddedToCart,
    double? averageRate,
    int? inStock,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      averageRate: averageRate ?? this.averageRate,
      inStock: inStock ?? this.inStock,
    );
  }

  Stream<int> get stockStream {
    // Replace with your actual Firestore query
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .snapshots()
        .map((snapshot) => snapshot['inStock'] as int);
  }
}

List<ProductItemModel> dummyProducts = [
  const ProductItemModel(
    id: 'gybeAnQTQhC1FcfakIGQ',
    name: 'chips ',
    imgUrl:
        'https://i.pinimg.com/564x/cc/09/26/cc09269ddc96e7900392d8aeba67f5af.jpg',
    price: 30,
    category: 'snacks',
    isFavorite: true,
    size: ProductSize.L,
  ),
  const ProductItemModel(
    id: '1hwtizSG8HeY0iyDJ7cB',
    name: 'hern ',
    imgUrl:
        'https://i.pinimg.com/564x/d9/7f/c2/d97fc2a506dcd1f61b5c848e3129dbf0.jpg',
    price: 20,
    category: 'drinks',
    size: ProductSize.L,
  ),
  const ProductItemModel(
    id: 'hDgs4iK1zbElsIm8Uh2N',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/736x/05/59/ab/0559abcd343d2743f9b128cbb8113d4f.jpg',
    price: 5,
    category: 'drinks',
    size: ProductSize.L,
  ),
  const ProductItemModel(
    id: '92gt8JNTGdPJo9BXj4RK',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/564x/aa/ad/22/aaad22bf99a5e34a85d491f8a520a304.jpg',
    price: 5,
    category: 'drinks',
    isAddedToCart: true,
    quantity: 3,
    size: ProductSize.S,
    isFavorite: true,
  ),
  const ProductItemModel(
    id: 'qaIfLI9tv5owQeh4G0Oz',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/564x/a3/d8/02/a3d802c3edd520bc1f08d5b537917c00.jpg',
    price: 5,
    category: 'drinks',
    isAddedToCart: true,
    quantity: 1,
    size: ProductSize.L,
  ),
];
