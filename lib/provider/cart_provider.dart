import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:flutter/foundation.dart';

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
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await cartServices.removeCartItem(productId);
      _cartItems = await cartServices.getCartItems();
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      notifyListeners();
    }
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  Future<void> incrementQuantity(String productId) async {
    try {
      final cartItem =
          _cartItems.firstWhere((item) => item.product.id == productId);
      if (cartItem.quantity < cartItem.product.inStock &&
          cartItem.product.inStock > 0) {
        await cartServices.incrementCartItemQuantity(productId);
        _cartItems = await cartServices.getCartItems();
        notifyListeners();
      } else {
        _errorMessage = 'Cannot exceed available stock';
        _state = CartState.error;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      notifyListeners();
    }
  }

  Future<void> decrementQuantity(String productId) async {
    try {
      await cartServices.decrementCartItemQuantity(productId);
      _cartItems = await cartServices.getCartItems();
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
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
