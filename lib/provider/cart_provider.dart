import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/product_item_model.dart';

enum CartState { initial, loading, loaded, error }

class CartProvider with ChangeNotifier {
  List<ProductItemModel> _cartItems = [];
  CartState _state = CartState.initial;
  String _errorMessage = '';

  List<ProductItemModel> get cartItems => _cartItems;
  CartState get state => _state;
  String get errorMessage => _errorMessage;

  double get subtotal {
    return _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * (item.quantity)),
    );
  }

  void removeFromCart(String productId) {
    final index = _cartItems.indexWhere(
      (item) => item.id == productId && item.isAddedToCart,
    );

    if (index != -1) {
      final item = _cartItems[index].copyWith(quantity: 0);
      _cartItems[index] = item;
      if (item.quantity == 0) {
        _cartItems.removeAt(index);
      }

      notifyListeners();
    }
  }

  void increment(String productId) {
    final index = _cartItems.indexWhere(
        (item) => item.id == productId && item.isAddedToCart == true);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (_cartItems[index].quantity) + 1,
      );
      notifyListeners();
    }
  }

  void decrement(String productId) {
    final index = _cartItems
        .indexWhere((item) => item.id == productId && item.isAddedToCart);
    if (index != -1 && (_cartItems[index].quantity) > 1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (_cartItems[index].quantity) - 1,
      );
      notifyListeners();
    }
  }

  void loadCartData() async {
    _state = CartState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _cartItems = dummyProducts.where((item) => item.isAddedToCart).toList();
      _state = CartState.loaded;
    } catch (error) {
      _state = CartState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }
}
