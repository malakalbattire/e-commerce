import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider with ChangeNotifier {
  Future<List<ProductItemModel>> fetchProductsByCategory(
      String category) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => ProductItemModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
