import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:flutter/foundation.dart';

abstract class CategoryServices {
  Future<void> addCategory(CategoryModel categoryModel);
  Future<void> removeCategory(String categoryId);
  Future<List<CategoryModel>> getCategoryItems();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<ProductItemModel>> getProductsByCategory(String category);
}

class CategoryServicesImpl implements CategoryServices {
  final firestore = FirestoreServices.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addCategory(CategoryModel categoryModel) async {
    return await firestore.setData(
      path: ApiPath.category(categoryModel.id),
      data: categoryModel.toJson(),
    );
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    final doc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .get();
    if (doc.exists) {
      return CategoryModel.fromJson(doc.data()!);
    } else {
      throw Exception('Category not found');
    }
  }

  @override
  Future<void> removeCategory(String categoryId) async {
    await firestore.deleteData(
      path: ApiPath.category(categoryId),
    );
  }

  @override
  Future<List<CategoryModel>> getCategoryItems() async {
    final path = ApiPath.categories();

    try {
      final categories = await firestore.getCollection(
        path: path,
        builder: (data, documentId) {
          return CategoryModel.fromJson(data);
        },
      );

      return categories;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
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
