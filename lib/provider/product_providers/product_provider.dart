import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String backendUrl = 'http://192.168.88.10:3000';

  Future<List<ProductItemModel>> fetchProductsByCategory(
      String category) async {
    final response =
        await http.get(Uri.parse('$backendUrl/products?category=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);

      return productData
          .map((data) => ProductItemModel.fromMap(data, data['id']))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('No products found for this category');
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }
}
