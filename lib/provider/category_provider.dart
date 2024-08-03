// import 'package:flutter/material.dart';
// import '../models/category_model.dart';
// import '../services/category_services.dart';
//
// enum CategoryState { initial, loading, loaded, error }
//
// class CategoryProvider with ChangeNotifier {
//   CategoryState _state = CategoryState.initial;
//   CategoryState get state => _state;
//
//   String _errorMessage = '';
//   String get errorMessage => _errorMessage;
//
//   List<CategoryModel> _categories = [];
//   List<CategoryModel> get categories => _categories;
//
//   final CategoryServices _categoryServices = CategoryServices();
//
//   Future<void> loadCategoryData() async {
//     _state = CategoryState.loading;
//     notifyListeners();
//
//     try {
//       _categories = await _categoryServices.fetchCategories();
//       _state = CategoryState.loaded;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _state = CategoryState.error;
//     }
//
//     notifyListeners();
//   }
// }
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

enum CategoryState { initial, loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CategoryModel> _categories = [];
  List<ProductItemModel> _products = [];
  CategoryState _state = CategoryState.initial;
  String _errorMessage = '';

  List<CategoryModel> get categories => _categories;
  List<ProductItemModel> get products => _products;
  CategoryState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> loadCategoryData() async {
    _state = CategoryState.loading;
    notifyListeners();

    try {
      final categorySnapshot = await _firestore.collection('categories').get();
      _categories = categorySnapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();

      _state = CategoryState.loaded;
    } catch (e) {
      _state = CategoryState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> loadProductsByCategory(String category) async {
    _state = CategoryState.loading;
    notifyListeners();

    try {
      final productSnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      _products = productSnapshot.docs
          .map((doc) => ProductItemModel.fromMap(doc.data(), doc.id))
          .toList();

      _state = CategoryState.loaded;
    } catch (e) {
      _state = CategoryState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }
}
