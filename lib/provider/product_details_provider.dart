import 'package:e_commerce_app_flutter/models/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:flutter/material.dart';

class ProductDetailsProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  int _quantity = 1;
  Size? _selectedSize;
  final List<AddToCartModel> _cartItems = [];
  final productDetailsServices = ProductDetailsServicesImpl();

  ProductItemModel? get selectedProduct => _selectedProduct;
  int get quantity => _quantity;
  Size? get selectedSize => _selectedSize;
  List<AddToCartModel> get cartItems => _cartItems;

  Future<void> getProductDetails(String id) async {
    try {
      final result = await productDetailsServices.getProductDetails(id);
      _selectedProduct = result;
      _quantity = 1;
      _selectedSize = null;
      notifyListeners();
    } catch (e) {
      print(e);
      // Handle error if necessary
    }
  }

  void setQuantity(int quantity) {
    if (quantity > 0) {
      _quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(String productId) {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setSize(Size size) {
    _selectedSize = size;
    notifyListeners();
  }

  Future<void> addToCart(String productId) async {
    try {
      if (_selectedProduct != null && _selectedSize != null) {
        final selectedProduct =
            await productDetailsServices.getProductDetails(productId);
        final cartItem = AddToCartModel(
          id: DateTime.now().toIso8601String(),
          product: selectedProduct,
          quantity: _quantity,
          size: _selectedSize!,
        );
        await productDetailsServices.addToCart(cartItem);
        _cartItems.add(cartItem);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
