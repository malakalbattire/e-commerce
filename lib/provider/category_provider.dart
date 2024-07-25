import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/category_model.dart';

enum CategoryState { initial, loading, loaded, error }

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categoryItems = [];
  CategoryState _state = CategoryState.initial;
  String _errorMessage = '';

  List<CategoryModel> get categoryItems => _categoryItems;
  CategoryState get state => _state;
  String get errorMessage => _errorMessage;

  void loadCategoryData() async {
    _state = CategoryState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _categoryItems = dummyCategories;

      _state = CategoryState.loaded;
    } catch (error) {
      _state = CategoryState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }
}
