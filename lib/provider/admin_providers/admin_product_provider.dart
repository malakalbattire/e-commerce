import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/addmin_product_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AdminProductProvider with ChangeNotifier {
  final AdminProductService _productService = AdminProductService.instance;
  late IO.Socket _socket;

  List<ProductItemModel> _products = [];
  List<ProductItemModel> get products => _products;

  AdminProductProvider() {
    _initializeSocket();
  }

  void _initializeSocket() {
    _socket = IO.io(BackendUrl.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      if (kDebugMode) {
        print('Connected to socket server');
      }
    });

    _socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('Disconnected from socket server');
      }
    });
  }

  Future<void> _sendNotification(
      String userId, String title, String body) async {}

  Future<void> addProduct(ProductItemModel product) async {
    try {
      await _productService.addProduct(data: product.toMap());

      _socket.emit('productAdded', product.toMap());

      await _sendNotification('admin', 'New Product Added',
          'A new product "${product.name}" has been added.');
      _products.add(product);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  Future<void> updateProduct(ProductItemModel product) async {
    try {
      await _productService.updateProduct(
          documentId: product.id, data: product.toMap());

      _socket.emit('productUpdated', product.toMap());

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index >= 0) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(documentId: productId);

      _socket.emit('productDeleted', {'id': productId});

      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {} catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
