import 'package:e_commerce_app_flutter/models/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/product_item_model.dart';

enum CartState { initial, loading, loaded, error }

class CartProvider with ChangeNotifier {
  final cartServices = CartServicesImpl();
  List<AddToCartModel> _cartItems = [];
  CartState _state = CartState.initial;
  String _errorMessage = '';

  List<AddToCartModel> get cartItems => _cartItems;
  CartState get state => _state;
  String get errorMessage => _errorMessage;

  double get subtotal {
    return _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * (item.quantity)),
    );
  }

  void removeFromCart(String productId) {
    final index = _cartItems.indexWhere(
      (item) => item.id == productId && item.product.isAddedToCart,
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
        (item) => item.id == productId && item.product.isAddedToCart == true);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (_cartItems[index].quantity) + 1,
      );
      notifyListeners();
    }
  }

  void decrement(String productId) {
    final index = _cartItems.indexWhere(
        (item) => item.id == productId && item.product.isAddedToCart);
    if (index != -1 && (_cartItems[index].quantity) > 1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (_cartItems[index].quantity) - 1,
      );
      notifyListeners();
    }
  }

  Future<void> loadCartData() async {
    _state = CartState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _cartItems = await cartServices.getCartItems();
      _state = CartState.loaded;
    } catch (error) {
      _state = CartState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }
}
