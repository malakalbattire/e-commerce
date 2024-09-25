import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  Future<List<ProductItemModel>> fetchProductsByCategory(
      String category) async {
    final response = await http
        .get(Uri.parse('${BackendUrl.url}/products?category=$category'));

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
