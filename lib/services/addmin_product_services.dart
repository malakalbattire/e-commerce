import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminProductService {
  AdminProductService._();
  static final instance = AdminProductService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  Future<void> addProduct({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = firestore.collection(path).doc();
    debugPrint('Adding product: $data');
    await reference.set(data);
  }

  Future<void> updateProduct({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final reference = firestore.collection(path).doc(documentId);
    debugPrint('Updating product: $data');
    await reference.update(data);
  }

  Future<void> deleteProduct(
      {required String path, required String documentId}) async {
    final reference = firestore.collection(path).doc(documentId);
    debugPrint('Deleting product with id: $documentId');
    await reference.delete();
  }
}
