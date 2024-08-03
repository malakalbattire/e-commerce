import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';

class CategoryServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<ProductItemModel>> getProductsByCategory(String category) async {
    final querySnapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return querySnapshot.docs
        .map((doc) => ProductItemModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
