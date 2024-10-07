import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class HomeServices {
  Future<List<ProductItemModel>> getProducts();
  Stream<List<ProductItemModel>> getProductsStream();
  Future<void> addProduct(ProductItemModel product);
  Future<void> deleteProduct(String id);
}

class HomeServicesImpl implements HomeServices {
  List<ProductItemModel> _cachedProducts = [];
  bool _isFetching = false;
  late IO.Socket _socket;

  HomeServicesImpl() {
    _socket = IO.io(BackendUrl.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('productAdded', (data) {
      final newProduct = ProductItemModel.fromMap(data, data['id']);
      _cachedProducts.add(newProduct);
    });

    _socket.on('productUpdated', (data) {
      final updatedProduct = ProductItemModel.fromMap(data, data['id']);
      final index =
          _cachedProducts.indexWhere((product) => product.id == data['id']);
      if (index != -1) {
        _cachedProducts[index] = updatedProduct;
      }
    });

    _socket.on('productDeleted', (data) {
      _cachedProducts.removeWhere((product) => product.id == data['id']);
    });
  }

  @override
  Future<List<ProductItemModel>> getProducts() async {
    if (_cachedProducts.isNotEmpty && !_isFetching) {
      return _cachedProducts;
    }

    try {
      _isFetching = true;
      final response = await http.get(Uri.parse('${BackendUrl.url}/products'));
      print('Backend URL: $BackendUrl.url');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _cachedProducts = data.map((product) {
          return ProductItemModel.fromMap(product, product['id']);
        }).toList();
        return _cachedProducts;
      } else {
        print('Failed to fetch products. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    } finally {
      _isFetching = false;
    }
  }

  @override
  Stream<List<ProductItemModel>> getProductsStream() async* {
    final products = await getProducts();
    yield products;
  }

  @override
  Future<void> addProduct(ProductItemModel product) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendUrl.url}/products'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(product.toMap()),
      );

      if (response.statusCode == 200) {
        _cachedProducts.add(product);
        _socket.emit('productAdded', product.toMap());
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('${BackendUrl.url}/products/$id'));

      if (response.statusCode == 200) {
        _cachedProducts.removeWhere((product) => product.id == id);
        _socket.emit('productDeleted', {'id': id});
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
