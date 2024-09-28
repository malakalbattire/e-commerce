import 'dart:convert';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class ProductItemService {
  Stream<String> getNameStream(String productId);
  Stream<String> getImgUrlStream(String productId);
  Stream<double> getPriceStream(String productId);
  Stream<String> getCategoryStream(String productId);
  Stream<int> getStockStream(String productId);
  Stream<String> getDescriptionStream(String productId);
  Future<void> deleteProduct(String productId);
}

class ProductItemServiceImpl implements ProductItemService {
  Future<Map<String, dynamic>> _fetchProductData(String productId) async {
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.url}/products/$productId'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching product data: $e');
      }
      throw Exception('Error fetching product data: $e');
    }
  }

  @override
  Stream<String> getNameStream(String productId) {
    return Stream.fromFuture(
        _fetchProductData(productId).then((data) => data['name'] as String));
  }

  @override
  Stream<String> getImgUrlStream(String productId) {
    return Stream.fromFuture(
        _fetchProductData(productId).then((data) => data['imgUrl'] as String));
  }

  @override
  Stream<double> getPriceStream(String productId) {
    return Stream.fromFuture(_fetchProductData(productId).then((data) {
      final price = data['price'];
      if (price is num) {
        return price.toDouble();
      } else {
        throw Exception('Price is not a valid number');
      }
    }));
  }

  @override
  Stream<String> getCategoryStream(String productId) {
    return Stream.fromFuture(_fetchProductData(productId)
        .then((data) => data['category'] as String));
  }

  @override
  Stream<String> getDescriptionStream(String productId) {
    return Stream.fromFuture(_fetchProductData(productId)
        .then((data) => data['description'] as String));
  }

  @override
  Stream<int> getStockStream(String productId) {
    return Stream.fromFuture(
        _fetchProductData(productId).then((data) => data['inStock'] as int));
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      final response =
          await http.delete(Uri.parse('${BackendUrl.url}/products/$productId'));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          if (kDebugMode) {
            print('Product deleted successfully');
          }
        }
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('Product not found');
        }
        throw Exception('Product not found');
      } else {
        if (kDebugMode) {
          print('Failed to delete product: ${response.reasonPhrase}');
        }
        throw Exception('Failed to delete product: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting product: $e');
      }
      throw Exception('Error deleting product: $e');
    }
  }
}
