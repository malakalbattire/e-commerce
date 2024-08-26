import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/category_services.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryServices _categoryServices = CategoryServicesImpl();

  List<CategoryModel> _categories = [];
  List<ProductItemModel> _productsByCategory = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  List<ProductItemModel> get productsByCategory => _productsByCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _categoryServices.getCategoryItems();
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    _isLoading = true;
    notifyListeners();
    try {
      _productsByCategory =
          await _categoryServices.getProductsByCategory(category);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryServices.addCategory(category);
      await fetchCategories();
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(BuildContext context, String categoryName) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.productsList,
      arguments: categoryName,
    );
  }

  Future<void> removeCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryServices.removeCategory(categoryId);
      await fetchCategories();
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      return await _categoryServices.getCategoryById(categoryId);
    } catch (e) {
      return null;
    }
  }
}
