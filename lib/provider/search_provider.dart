import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      _searchResults = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ProductItemModel.fromMap(data, doc.id);
      }).toList();
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
