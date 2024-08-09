import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/addmin_product_services.dart';
import 'package:flutter/material.dart';

class AdminProductProvider with ChangeNotifier {
  final AdminProductService _productService = AdminProductService.instance;

  List<ProductItemModel> _products = [];
  List<ProductItemModel> get products => _products;

  Future<void> addProduct(ProductItemModel product) async {
    try {
      await _productService.addProduct(
        path: 'products',
        data: product.toMap(),
      );
      _products.add(product);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  Future<void> updateProduct(ProductItemModel product) async {
    try {
      await _productService.updateProduct(
        path: 'products',
        documentId: product.id,
        data: product.toMap(),
      );
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
      await _productService.deleteProduct(
        path: 'products',
        documentId: productId,
      );
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      // Fetch products logic can be implemented here using collectionStream from FirestoreServices
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }
}
