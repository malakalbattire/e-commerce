import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  List<ProductItemModel> _searchResults = [];
  List<ProductItemModel> get searchResults => _searchResults;

  final TextEditingController searchController = TextEditingController();

  SearchProvider() {
    searchController.addListener(() {
      _searchProducts(searchController.text);
    });
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${BackendUrl.url}/products?name=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);

        _searchResults = results.map((data) {
          final id = data['id'] as String;
          return ProductItemModel.fromMap(data, id);
        }).toList();
      } else if (response.statusCode == 404) {
        _searchResults = [];
      } else {
        print('Error fetching products: ${response.statusCode}');
        _searchResults = [];
      }
    } catch (e) {
      print('Error searching products: $e');
      _searchResults = [];
    }

    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
