import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_services.dart';

enum CategoryState { initial, loading, loaded, error }

class CategoryProvider with ChangeNotifier {
  CategoryState _state = CategoryState.initial;
  CategoryState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  final CategoryServices _categoryServices = CategoryServices();

  Future<void> loadCategoryData() async {
    _state = CategoryState.loading;
    notifyListeners();

    try {
      _categories = await _categoryServices.fetchCategories();
      _state = CategoryState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = CategoryState.error;
    }

    notifyListeners();
  }
}
