import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:e_commerce_app_flutter/services/product_details_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProductDetailsProvider with ChangeNotifier {
  Map<String, ProductItemModel> _products = {};
  int _quantity = 1;
  double _price = 0.0;
  Size? _selectedSize;
  ProductColor? _selectedColor;
  final CartServicesImpl cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();
  IO.Socket? socket;

  final List<AddToCartModel> _cartItems = [];
  final ProductDetailsServicesImpl productDetailsServices =
      ProductDetailsServicesImpl();

  ProductItemModel? get selectedProduct =>
      _products.isNotEmpty ? _products.values.first : null;
  int get quantity => _quantity;
  Size? get selectedSize => _selectedSize;
  ProductColor? get selectedColor => _selectedColor;
  List<AddToCartModel> get cartItems => _cartItems;

  ProductDetailsProvider() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io('${BackendUrl.url}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      print('Connected to Socket.IO server');
    });

    socket?.on('productStockUpdated', (data) {
      print('Product stock updated via socket: $data');
      final productId = data['product_id'];
      final newStock = data['new_stock'];
      _updateStockInProvider(productId, newStock);
    });

    socket?.on('productDetailsUpdated', (data) {
      print('Product details updated via socket: $data');
      final productId = data['product_id'];
      _fetchUpdatedProductDetails(productId);
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  Future<void> _fetchUpdatedProductDetails(String productId) async {
    try {
      final updatedProduct =
          await productDetailsServices.getProductDetails(productId);
      _products[productId] = updatedProduct;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching updated product details: $e');
      }
    }
  }

  Future<void> _updateStockInProvider(String productId, int newStock) async {
    final product = _products[productId];
    if (product != null) {
      _products[productId] = product.copyWith(inStock: newStock);
      notifyListeners();
    }
  }

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

  ProductItemModel? getProductById(String id) {
    return _products[id];
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
      default:
        return Size.OneSize;
    }
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
      final currentUser = await authServices.getUser();
      if (currentUser == null) return;

      final product = selectedProduct;
      if (product == null) return;

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
        userId: currentUser.id,
      );

      final url = Uri.parse('${BackendUrl.url}/cart');
      final body = jsonEncode(newCartItem.toMap());

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        socket?.emit('cartItemAdded', {
          'user_id': currentUser.id,
          'product_id': productId,
          'quantity': quantity,
          'action': 'added',
        });

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
      } else if (response.statusCode == 200) {
        socket?.emit('cartItemUpdated', {
          'user_id': currentUser.id,
          'product_id': productId,
          'quantity': quantity,
          'action': 'updated',
        });

        Fluttertoast.showToast(
          msg: "Cart item quantity updated.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.4),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        notifyListeners();
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMessage = errorResponse['error'] ?? 'Unknown error';
        Fluttertoast.showToast(
          msg: "Error: $errorMessage",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.withOpacity(0.4),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item to cart: $e');
      }
      Fluttertoast.showToast(
        msg: "An error occurred while adding the item to the cart.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.withOpacity(0.4),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
