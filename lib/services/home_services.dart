import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HomeServices {
  Future<List<ProductItemModel>> getProducts();
  Stream<List<ProductItemModel>> getProductsStream();
  Future<void> addProduct(ProductItemModel product);
  Future<void> deleteProduct(String id);
}

class HomeServicesImpl implements HomeServices {
  List<ProductItemModel> _cachedProducts = [];
  bool _isFetching = false;

  @override
  Future<List<ProductItemModel>> getProducts() async {
    if (_cachedProducts.isNotEmpty && !_isFetching) {
      return _cachedProducts;
    }

    try {
      _isFetching = true;
      final response = await http.get(Uri.parse('${BackendUrl.url}/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _cachedProducts = data.map((product) {
          return ProductItemModel.fromMap(product, product['id']);
        }).toList();
        return _cachedProducts;
      } else {
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
    if (_cachedProducts.isNotEmpty) {
      yield _cachedProducts;
    }

    yield* Stream.periodic(Duration(seconds: 10)).asyncMap((_) async {
      try {
        return await getProducts();
      } catch (e) {
        print('Error in periodic product stream: $e');
        return _cachedProducts;
      }
    });
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
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print('Error adding product: $e');
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
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception('Error deleting product: $e');
    }
  }
}
