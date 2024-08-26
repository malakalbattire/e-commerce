import 'dart:io';

import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> addCategory(String name, File? imageFile) async {
    _isLoading = true;
    notifyListeners();
    try {
      String? imgUrl;
      if (imageFile != null) {
        imgUrl = await uploadImage(imageFile);
      }

      final newCategory = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        imgUrl: imgUrl ?? '',
      );

      await _categoryServices.addCategory(newCategory);

      await fetchCategories();
    } catch (e) {
      print('Error adding category: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'categories/${DateTime.now().millisecondsSinceEpoch.toString()}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
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
