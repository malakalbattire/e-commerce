import 'dart:async';
import 'dart:io';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:e_commerce_app_flutter/services/category_services.dart';
import 'package:image_picker/image_picker.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryServices _categoryServices = CategoryServicesImpl();
  final StreamController<List<CategoryModel>> _categoryStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  File? _imageFile;

  File? get imageFile => _imageFile;
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

  Future<void> addCategory(String name) async {
    _isLoading = true;
    notifyListeners();
    try {
      String? imgUrl;
      if (_imageFile != null) {
        imgUrl = await uploadImageToStorage(_imageFile!);
      }

      final newCategory = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        imgUrl: imgUrl ?? '',
      );

      await _categoryServices.addCategory(newCategory);
      fetchCategories();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding category: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('categories/$fileName');

      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      throw Exception('Error uploading image: $e');
    }
  }

  void selectCategory(BuildContext context, String categoryName) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.productsList,
      arguments: categoryName,
    );
  }

  Future<void> submitCategory(String categoryName, BuildContext context) async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    try {
      await addCategory(categoryName);
      Navigator.pop(context, categoryName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> removeCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryServices.removeCategory(categoryId);
      fetchCategories();
    } catch (e) {
      if (kDebugMode) {
        print('Error removing category: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CategoryModel?> getProductsByCategory(String category) async {
    try {
      return await _categoryServices.getCategoryById(category);
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
