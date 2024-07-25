enum Size { S, M, L, xL }

class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final bool isFavorite;
  final String description;
  final double price;
  final String category;
  final int quantity;
  final Size? size;
  final bool isAddedToCart;

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
  });
  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    bool? isFavorite,
    String? description,
    double? price,
    String? category,
    int? quantity,
    Size? size,
    bool? isAddedToCart,
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
    );
  }
}

List<ProductItemModel> dummyProducts = [
  const ProductItemModel(
    id: '1',
    name: 'Lip Oil-Berry ',
    imgUrl:
        'https://i.pinimg.com/564x/68/28/fd/6828fd5d65bba355774fa291e8af322e.jpg',
    price: 10,
    category: 'make up',
    isAddedToCart: true,
    quantity: 2,
    size: Size.L,
    isFavorite: true,
  ),
  const ProductItemModel(
    id: '2',
    name: 'chips ',
    imgUrl:
        'https://i.pinimg.com/564x/cc/09/26/cc09269ddc96e7900392d8aeba67f5af.jpg',
    price: 30,
    category: 'snakes',
    isFavorite: true,
  ),
  const ProductItemModel(
    id: '3',
    name: 'hern ',
    imgUrl:
        'https://i.pinimg.com/564x/d9/7f/c2/d97fc2a506dcd1f61b5c848e3129dbf0.jpg',
    price: 20,
    category: 'drinks',
  ),
  const ProductItemModel(
    id: '4',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/736x/05/59/ab/0559abcd343d2743f9b128cbb8113d4f.jpg',
    price: 5,
    category: 'drinks',
  ),
  const ProductItemModel(
    id: '5',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/564x/aa/ad/22/aaad22bf99a5e34a85d491f8a520a304.jpg',
    price: 5,
    category: 'drinks',
    isAddedToCart: true,
    quantity: 3,
    size: Size.S,
    isFavorite: true,
  ),
  const ProductItemModel(
    id: '6',
    name: 'drink ',
    imgUrl:
        'https://i.pinimg.com/564x/a3/d8/02/a3d802c3edd520bc1f08d5b537917c00.jpg',
    price: 5,
    category: 'drinks',
    isAddedToCart: true,
    quantity: 1,
  ),
];
