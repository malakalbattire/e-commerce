import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HomeServices {
  Future<List<ProductItemModel>> getProducts();
  Stream<List<ProductItemModel>> getProductsStream();
  Future<void> addProduct(ProductItemModel product);
  Future<void> deleteProduct(String id);
}

class HomeServicesImpl implements HomeServices {
  final String backendUrl = 'http://192.168.88.5:3000';

  @override
  Future<List<ProductItemModel>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductItemModel> products = data.map((product) {
          return ProductItemModel.fromMap(product, product['id']);
        }).toList();
        return products;
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Stream<List<ProductItemModel>> getProductsStream() {
    return Stream.periodic(Duration(seconds: 10))
        .asyncMap((_) => getProducts());
  }

  @override
  Future<void> addProduct(ProductItemModel product) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/products'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(product.toMap()),
      );

      if (response.statusCode != 200) {
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
      final response = await http.delete(Uri.parse('$backendUrl/products/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception('Error deleting product: $e');
    }
  }
}
