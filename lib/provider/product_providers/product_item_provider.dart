import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/product_item_service.dart';

enum ProductItemState { initial, loading, loaded, error }

class ProductItemProvider with ChangeNotifier {
  final ProductItemServiceImpl productItemServices = ProductItemServiceImpl();

  Stream<String> getNameStream(String productId) {
    return productItemServices.getNameStream(productId);
  }

  Stream<String> getImgUrlStream(String productId) {
    return productItemServices.getImgUrlStream(productId);
  }

  Stream<double> getPriceStream(String productId) {
    return productItemServices.getPriceStream(productId);
  }

  Stream<String> getCategoryStream(String productId) {
    return productItemServices.getCategoryStream(productId);
  }

  Stream<String> getDescriptionStream(String productId) {
    return productItemServices.getDescriptionStream(productId);
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await productItemServices.deleteProduct(productId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Stream<int> getStockStream(String productId) {
    return productItemServices.getStockStream(productId);
  }
}
