import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminProductService {
  AdminProductService._();
  static final instance = AdminProductService._();

  Future<void> addProduct({
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('${BackendUrl.url}/products');

    debugPrint('Adding product: $data');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      debugPrint('Product added successfully');
    } else {
      debugPrint('Failed to add product: ${response.body}');
    }
  }

  Future<void> updateProduct({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('${BackendUrl.url}/products/$documentId');

    debugPrint('Updating product: $data');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      debugPrint('Product updated successfully');
    } else {
      debugPrint('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct({
    required String documentId,
  }) async {
    final url = Uri.parse('${BackendUrl.url}/products/$documentId');

    debugPrint('Deleting product with id: $documentId');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      debugPrint('Product deleted successfully');
    } else {
      debugPrint('Failed to delete product: ${response.body}');
    }
  }
}
