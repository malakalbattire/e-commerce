import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AddProductServices {
  Future<void> addProduct(AddProductModel productModel);
  Future<String> uploadImageToStorage(File image);
}

class AddProductServicesImpl implements AddProductServices {
  @override
  Future<void> addProduct(AddProductModel productModel) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendUrl.url}/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productModel.toMap()),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Product added successfully');
        }
      } else {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding product: $e');
      }
      throw Exception('Error adding product: $e');
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
}
