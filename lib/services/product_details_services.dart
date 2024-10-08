import 'dart:convert';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ProductDetailsServices {
  Future<ProductItemModel> getProductDetails(String id);
  Stream<List<ProductSize>> getProductSizes(String productId);
  Future<void> updateProductStock(String productId, int newStock);
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final authServices = AuthServicesImpl();
  IO.Socket? socket;

  ProductDetailsServicesImpl() {
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
    });

    socket?.on('productDetailsUpdated', (data) {
      print('Product details updated via socket: $data');
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    final response =
        await http.get(Uri.parse('${BackendUrl.url}/products/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductItemModel.fromMap(data, id);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Stream<List<ProductSize>> getProductSizes(String productId) async* {
    final response =
        await http.get(Uri.parse('${BackendUrl.url}/products/$productId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final sizes = (data['sizes'] as List<dynamic>)
          .map((item) => ProductSize.values
              .firstWhere((size) => size.name == item as String))
          .toList();
      yield sizes;
    } else {
      yield [];
    }
  }

  @override
  Future<void> updateProductStock(String productId, int newStock) async {
    final response = await http.put(
      Uri.parse('${BackendUrl.url}/products/$productId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'inStock': newStock}),
    );

    if (response.statusCode == 200) {
      socket?.emit('productStockUpdated', {
        'product_id': productId,
        'new_stock': newStock,
      });
    } else {
      throw Exception('Failed to update product stock');
    }
  }

  @override
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields) async {
    final response = await http.put(
      Uri.parse('${BackendUrl.url}/products/$productId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedFields),
    );

    if (response.statusCode == 200) {
      socket?.emit('productDetailsUpdated', {
        'product_id': productId,
        ...updatedFields,
      });
    } else {
      throw Exception('Failed to update product details');
    }
  }
}
