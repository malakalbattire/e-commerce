import 'dart:convert';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:http/http.dart' as http;

abstract class ProductDetailsServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToCart(AddToCartModel addToCartModel);
  Stream<List<ProductSize>> getProductSizes(String productId);
  Future<void> updateProductStock(String productId, int newStock);
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final authServices = AuthServicesImpl();
  final String apiBaseUrl = 'http://192.168.88.2:3000';

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    final response = await http.get(Uri.parse('$apiBaseUrl/products/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductItemModel.fromMap(data, id);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Future<void> addToCart(AddToCartModel addToCartModel) async {
    final currentUser = await authServices.getUser();
    final response = await http.post(
      Uri.parse('$apiBaseUrl/users/${currentUser!.uid}/cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(addToCartModel.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to cart');
    } else {
      print('added to cart =======');
    }
  }

  @override
  Stream<List<ProductSize>> getProductSizes(String productId) async* {
    final response =
        await http.get(Uri.parse('$apiBaseUrl/products/$productId'));

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
      Uri.parse('$apiBaseUrl/products/$productId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'inStock': newStock}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product stock');
    }
  }

  @override
  Future<void> updateProductDetails(
      String productId, Map<String, dynamic> updatedFields) async {
    final response = await http.put(
      Uri.parse('$apiBaseUrl/products/$productId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedFields),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product details');
    }
  }
}
