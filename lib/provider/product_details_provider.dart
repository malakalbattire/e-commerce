import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:flutter/foundation.dart';

class ProductDetailsProvider with ChangeNotifier {
  Map<String, ProductItemModel> _products = {}; // To store multiple products
  int _quantity = 1;
  double _price = 0.0;
  Size? _selectedSize;
  final List<AddToCartModel> _cartItems = [];
  final ProductDetailsServicesImpl productDetailsServices =
      ProductDetailsServicesImpl();

  ProductItemModel? get selectedProduct =>
      _products.isNotEmpty ? _products.values.first : null;
  int get quantity => _quantity;
  Size? get selectedSize => _selectedSize;
  List<AddToCartModel> get cartItems => _cartItems;

  Future<void> getProductDetails(String id) async {
    try {
      final result = await productDetailsServices.getProductDetails(id);
      _products[id] = result;
      _quantity = 1;
      _selectedSize = null;
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

  double get totalPrice => _price * _quantity;

  Future<void> addToCart(String productId) async {
    try {
      final selectedProduct = _products[productId];
      if (selectedProduct != null &&
          _quantity <= selectedProduct.inStock &&
          _selectedSize != null) {
        final cartItem = AddToCartModel(
          id: selectedProduct.id,
          product: selectedProduct,
          size: _selectedSize!,
          quantity: _quantity,
          price: _price,
          imgUrl: selectedProduct.imgUrl,
          name: selectedProduct.name,
          inStock: selectedProduct.inStock,
        );
        await productDetailsServices.addToCart(cartItem);
        _cartItems.add(cartItem);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to cart: $e');
      }
    }
  }
}
