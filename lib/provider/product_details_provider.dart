import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProductDetailsProvider with ChangeNotifier {
  Map<String, ProductItemModel> _products = {};
  int _quantity = 1;
  double _price = 0.0;
  Size? _selectedSize;
  ProductColor? _selectedColor;
  final List<AddToCartModel> _cartItems = [];
  final ProductDetailsServicesImpl productDetailsServices =
      ProductDetailsServicesImpl();

  ProductItemModel? get selectedProduct =>
      _products.isNotEmpty ? _products.values.first : null;
  int get quantity => _quantity;
  Size? get selectedSize => _selectedSize;
  ProductColor? get selectedColor => _selectedColor;
  List<AddToCartModel> get cartItems => _cartItems;

  Future<void> getProductDetails(String id) async {
    try {
      final result = await productDetailsServices.getProductDetails(id);
      _products[id] = result;
      _quantity = 1;
      _selectedSize = null;
      _selectedColor = null;
      _price = result.price;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching product details: $e');
      }
    }
  }

  Future<void> getProductsDetails(List<String> ids) async {
    try {
      final results = await Future.wait(
        ids.map((id) => productDetailsServices.getProductDetails(id)),
      );
      _products = Map.fromIterables(ids, results);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products details: $e');
      }
    }
  }

  ProductItemModel? getProductById(String id) {
    return _products[id];
  }

  void setQuantity(int quantity) {
    if (quantity > 0 && quantity <= _products.values.first.inStock) {
      _quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    if (_quantity < _products.values.first.inStock) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setSize(Size size) {
    _selectedSize = size;
    notifyListeners();
  }

  void setColor(ProductColor color) {
    _selectedColor = color;
    notifyListeners();
  }

  double get totalPrice => _price * _quantity;
  Future<void> addToCart(String productId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('cart');

    final cartSnapshot = await cartRef
        .where('product.id', isEqualTo: productId)
        .where('size', isEqualTo: selectedSize?.name ?? 'One Size')
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      final doc = cartSnapshot.docs.first;
      final currentQuantity = doc['quantity'] as int;
      doc.reference.update({
        'quantity': currentQuantity + quantity,
      });
    } else {
      final newCartItem = AddToCartModel(
        id: productId,
        product: selectedProduct!,
        size: selectedSize ?? Size.OneSize,
        quantity: quantity,
        price: selectedProduct!.price,
        imgUrl: selectedProduct!.imgUrl,
        name: selectedProduct!.name,
        inStock: selectedProduct!.inStock,
      );
      cartRef.add(newCartItem.toMap());
    }
  }
}
