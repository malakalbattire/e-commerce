import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CartState { initial, loading, loaded, error }

enum ItemState { none, loading }

class CartProvider with ChangeNotifier {
  Map<String, ProductItemModel> _products = {};
  Map<String, ProductItemModel> get products => _products;

  final CartServicesImpl cartServices = CartServicesImpl();
  ProductItemModel? get selectedProduct =>
      _products.isNotEmpty ? _products.values.first : null;
  List<AddToCartModel> _cartItems = [];
  CartState _state = CartState.initial;
  final Map<String, ItemState> _itemStates = {};
  int _quantity = 1;

  Size? _selectedSize;
  ProductColor? _selectedColor;
  String _errorMessage = '';
  bool _pageLoading = false;

  List<AddToCartModel> get cartItems => _cartItems;
  CartState get state => _state;

  int get quantity => _quantity;
  Size? get selectedSize => _selectedSize;
  ProductColor? get selectedColor => _selectedColor;
  String get errorMessage => _errorMessage;
  Map<String, ItemState> get itemStates => _itemStates;
  bool get pageLoading => _pageLoading;

  double get subtotal {
    return _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void subscribeToCart(String userId) {
    _state = CartState.loading;
    notifyListeners();

    cartServices.getCartItemsStream(userId).listen((cartItems) async {
      List<AddToCartModel> updatedCartItems = [];

      for (var cartItem in cartItems) {
        try {
          updatedCartItems.add(cartItem);
        } catch (e) {
          if (kDebugMode) {
            print('Error processing cart item: $e');
          }
        }
      }

      _cartItems = updatedCartItems;
      _state = CartState.loaded;
      notifyListeners();
    }, onError: (error) {
      _state = CartState.error;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  int get cartItemCount => _cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

  CartProvider() {
    _listenToAuthChanges();
  }
  Future<void> addToCart(String productId, int quantity) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart');

      final product = selectedProduct;
      if (product == null) return;

      final size = selectedSize?.name ?? 'One Size';
      final color = selectedColor?.name ?? 'DefaultColor';

      final cartSnapshot = await cartRef
          .where('product.id', isEqualTo: productId)
          .where('size', isEqualTo: size)
          .where('color', isEqualTo: color)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        final doc = cartSnapshot.docs.first;
        final currentQuantity = doc['quantity'] as int;

        if (currentQuantity + quantity > product.inStock) {
          Fluttertoast.showToast(
            msg: "Cannot add more items. Exceeds stock limit.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.4),
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final docSnapshot = await transaction.get(doc.reference);
          if (docSnapshot.exists) {
            transaction.update(doc.reference, {
              'quantity': currentQuantity + quantity,
            });
          }
        });
      } else {
        final newCartItem = AddToCartModel(
          id: productId,
          product: product,
          size: selectedSize ?? Size.OneSize,
          quantity: quantity,
          price: product.price,
          imgUrl: product.imgUrl,
          name: product.name,
          inStock: product.inStock,
          color: selectedColor?.name ?? 'DefaultColor',
        );

        await cartRef.add(newCartItem.toMap());

        _cartItems.add(newCartItem);
      }

      Fluttertoast.showToast(
        msg: "Added to cart successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.4),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item to cart: $e');
      }
    }
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _clearCart();
      } else {
        subscribeToCart(user.uid);
      }
    });
  }

  void _clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> clearCart() async {
    try {
      await cartServices.clearCart();
      _clearCart();
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await cartServices.removeCartItem(productId);
      _cartItems.removeWhere((item) => item.product.id == productId);
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
      await cartServices.incrementCartItemQuantity(productId);
      _cartItems = await cartServices.getCartItems();
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
    }
    notifyListeners();
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
    } catch (error) {
      _errorMessage = error.toString();
      _state = CartState.error;
      _itemStates[productId] = ItemState.none;
      _pageLoading = false;
    }
    notifyListeners();
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
