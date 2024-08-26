import 'dart:async';
import 'dart:io';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:e_commerce_app_flutter/services/category_services.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryServices _categoryServices = CategoryServicesImpl();
  final StreamController<List<CategoryModel>> _categoryStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Stream<List<CategoryModel>> get categoryStream =>
      _categoryStreamController.stream;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _categoryServices.getCategoryItems();
      _categoryStreamController.add(_categories);
    } catch (e) {
      _categoryStreamController.addError('Failed to load categories');
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
      fetchCategories();
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
      fetchCategories();
    } catch (e) {
      print('Error removing category: $e');
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

  @override
  void dispose() {
    _categoryStreamController.close();
    super.dispose();
  }
}
