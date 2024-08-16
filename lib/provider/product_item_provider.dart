import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/product_item_service.dart';

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

  Stream<int> getStockStream(String productId) {
    return productItemServices.getStockStream(productId);
  }
}
