import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:flutter/foundation.dart';

enum CartState { initial, loading, loaded, error }

enum ItemState { none, loading }

class CartProvider with ChangeNotifier {
  final cartServices = CartServicesImpl();
  List<AddToCartModel> _cartItems = [];
  CartState _state = CartState.initial;
  final Map<String, ItemState> _itemStates = {};
  String _errorMessage = '';
  bool _pageLoading = false;

  List<AddToCartModel> get cartItems => _cartItems;
  CartState get state => _state;
  String get errorMessage => _errorMessage;
  Map<String, ItemState> get itemStates => _itemStates;
  bool get pageLoading => _pageLoading;

  double get subtotal {
    return _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get cartItemCount => _cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
  CartProvider() {
    _init();
  }
  void _init() {
    cartServices.getCartItemsStream().listen((cartItems) {
      _cartItems = cartItems;
      _state = CartState.loaded;
      notifyListeners();
    }).onError((error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      notifyListeners();
    });
  }

  Future<void> clearCart() async {
    await cartServices.clearCart();
    cartItems.clear();
    notifyListeners();
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
    _itemStates[productId] = ItemState.loading;
    _pageLoading = true;
    notifyListeners();
    try {
      final cartItem =
          _cartItems.firstWhere((item) => item.product.id == productId);
      if (cartItem.quantity < cartItem.product.inStock &&
          cartItem.product.inStock > 0) {
        await cartServices.incrementCartItemQuantity(productId);
        _cartItems = await cartServices.getCartItems();
        _itemStates[productId] = ItemState.none;
        _pageLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Cannot exceed available stock';
        _state = CartState.error;
        _itemStates[productId] = ItemState.none;
        _pageLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
      notifyListeners();
    }
  }

  Future<void> decrementQuantity(String productId) async {
    _itemStates[productId] = ItemState.loading;
    _pageLoading = true;
    notifyListeners();
    try {
      await cartServices.decrementCartItemQuantity(productId);
      _cartItems = await cartServices.getCartItems();
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
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
