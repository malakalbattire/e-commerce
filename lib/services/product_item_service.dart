import 'dart:convert';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ProductItemService {
  Stream<String> getNameStream(String productId);
  Stream<String> getImgUrlStream(String productId);
  Stream<double> getPriceStream(String productId);
  Stream<String> getCategoryStream(String productId);
  Stream<int> getStockStream(String productId);
  Stream<String> getDescriptionStream(String productId);
  Future<void> deleteProduct(String productId);
  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData);
}

class ProductItemServiceImpl implements ProductItemService {
  late IO.Socket _socket;

  ProductItemServiceImpl() {
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
          print('Product deleted successfully');
        }
        _socket.emit('productDeleted', {'id': productId});
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

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('${BackendUrl.url}/products/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Product updated successfully');
        }
        _socket.emit('productUpdated', {'id': productId, ...updatedData});
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('Product not found');
        }
        throw Exception('Product not found');
      } else {
        if (kDebugMode) {
          print('Failed to update product: ${response.reasonPhrase}');
        }
        throw Exception('Failed to update product: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product: $e');
      }
      throw Exception('Error updating product: $e');
    }
  }

  void closeSocket() {
    _socket.disconnect();
  }
}
