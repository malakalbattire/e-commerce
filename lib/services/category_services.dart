import 'dart:io';
import 'package:e_commerce_app_flutter/models/category_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class CategoryServices {
  Future<void> addCategory(CategoryModel categoryModel);
  Future<void> removeCategory(String categoryId);
  Future<List<CategoryModel>> getCategoryItems();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<ProductItemModel>> getProductsByCategory(String category);
  Future<String> uploadImageToStorage(File image);
}

class CategoryServicesImpl implements CategoryServices {
  @override
  Future<void> removeCategory(String categoryId) async {
    final url = Uri.parse('${BackendUrl.url}/categories/$categoryId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Category deleted successfully');
      }
    } else if (response.statusCode == 404) {
      if (kDebugMode) {
        print('Category not found');
      }
    } else {
      if (kDebugMode) {
        print('Failed to delete category: ${response.body}');
      }
      throw Exception('Failed to delete category');
    }
  }

  @override
  Future<List<ProductItemModel>> getProductsByCategory(String category) async {
    if (kDebugMode) {
      print("$category category name ==========");
    }

    final response = await http
        .get(Uri.parse('${BackendUrl.url}/products?category=$category'));
    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      if (productData.isEmpty) {
        if (kDebugMode) {
          print('No products found for this category.');
        }
      }
      return productData
          .map((data) => ProductItemModel.fromMap(data, data['id']))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<void> addCategory(CategoryModel categoryModel) async {
    final url = Uri.parse('${BackendUrl.url}/categories');

    final updatedCategoryModel = categoryModel.copyWith(
      imgUrl: categoryModel.imgUrl.isNotEmpty
          ? categoryModel.imgUrl
          : 'defaultImageUrl',
    );

    final body = json.encode(updatedCategoryModel.toMap());

    if (kDebugMode) {
      print("Sending request to $url with body: $body");
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 201) {
      if (kDebugMode) {
        print("Response: ${response.statusCode} - ${response.body}");
      }
      throw Exception('Failed to add category to categories');
    }
  }

  @override
  Future<String> uploadImageToStorage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('productsImg/$fileName');

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

  @override
  Future<List<CategoryModel>> getCategoryItems() async {
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.url}/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
      return [];
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response =
          await http.get(Uri.parse('${BackendUrl.url}/categories/$categoryId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CategoryModel.fromJson(data);
      } else {
        throw Exception('Category not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching category by ID: $e');
      }
      throw Exception('Error fetching category by ID');
    }
  }
}
