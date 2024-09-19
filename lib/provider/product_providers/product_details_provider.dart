import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsProvider with ChangeNotifier {
  Map<String, ProductItemModel> _products = {};
  int _quantity = 1;
  double _price = 0.0;
  Size? _selectedSize;
  ProductColor? _selectedColor;
  final CartServicesImpl cartServices = CartServicesImpl();

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

  Size convertProductSizeToSize(ProductSize productSize) {
    switch (productSize) {
      case ProductSize.S:
        return Size.S;
      case ProductSize.M:
        return Size.M;
      case ProductSize.L:
        return Size.L;
      case ProductSize.xL:
        return Size.xL;
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

  Stream<List<ProductSize>> get sizesStream {
    final product = selectedProduct;
    if (product == null) return Stream.value([]);

    return productDetailsServices.getProductSizes(product.id);
  }

  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields) async {
    try {
      await productDetailsServices.updateProductDetails(
          productId, updatedFields);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product details: $e');
      }
    }
  }

  Future<void> updateProductStock(String productId, int newStock) async {
    try {
      await productDetailsServices.updateProductStock(productId, newStock);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product stock: $e');
      }
    }
  }

  double get totalPrice => _price * _quantity;
  Future<void> addToCart(String productId) async {
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
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          product: product,
          size: selectedSize ?? Size.OneSize,
          quantity: quantity,
          price: product.price,
          imgUrl: product.imgUrl,
          name: product.name,
          inStock: product.inStock,
          color: selectedColor?.name ?? 'DefaultColor',
          userId: currentUser.uid,
        );
        await cartServices.addToCart(newCartItem);
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
}
