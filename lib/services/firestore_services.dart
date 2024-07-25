import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreServices {
  FirestoreServices._();
  static final instance = FirestoreServices._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = firestore.doc(path);
    debugPrint('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = firestore.doc(path);
    debugPrint('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Object? data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = firestore.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Object? data, String documentID) builder,
  }) {
    final reference = firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Future<T> getDocument<T>({
    required String path,
    required T Function(Object? data, String documentId) builder,
  }) async {
    final reference = firestore.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data(), snapshot.id);
  }

  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Object? data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.get();
    final result = snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }
}
