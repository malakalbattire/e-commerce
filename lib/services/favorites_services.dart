import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';

abstract class FavoritesServices {
  Future<ProductItemModel> getProductDetails(String id);
  Future<void> addToFav(FavoriteModel addToFavModel);
  Future<void> removeFromFav(String productId);
  Future<List<FavoriteModel>> getFavItems(String userId);
  Stream<List<FavoriteModel>> getFavItemsStream(String userId);
  Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds);
}

class FavServicesImpl implements FavoritesServices {
  final String backendUrl = 'http://192.168.88.2:3000';
  final authServices = AuthServicesImpl();

  Future<String> _getCurrentUserId() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is signed in.');
    }
    return currentUser.uid;
  }

  @override
  Future<void> addToFav(FavoriteModel addToFavModel) async {
    final userId = await _getCurrentUserId();
    final response = await http.post(
      Uri.parse('$backendUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'product_id': addToFavModel.id,
        'is_favorite': true
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites');
    } else {
      print('add to favorites');
    }
  }

  @override
  Future<void> removeFromFav(String productId) async {
    final userId = await _getCurrentUserId();
    final response = await http.post(
      Uri.parse('$backendUrl/favorites/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    } else {
      print('removed');
    }
  }

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    final response = await http.get(Uri.parse('$backendUrl/products/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductItemModel.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Future<List<FavoriteModel>> getFavItems(String userId) async {
    final response = await http.get(Uri.parse('$backendUrl/favorites/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FavoriteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite items');
    }
  }

  @override
  Stream<List<FavoriteModel>> getFavItemsStream(String userId) {
    return Stream.periodic(Duration(seconds: 30), (_) async {
      final response =
          await http.get(Uri.parse('$backendUrl/favorites/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FavoriteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite items');
      }
    }).asyncMap((future) => future);
  }

  @override
  Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
    return Stream.periodic(Duration(seconds: 30), (_) async {
      final List<ProductItemModel> products = [];
      for (String id in favoriteIds) {
        final response = await http.get(Uri.parse('$backendUrl/products/$id'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          products.add(ProductItemModel.fromJson(data));
        } else {
          throw Exception('Failed to load product details');
        }
      }
      return products;
    }).asyncMap((future) => future);
  }
  // @override
  // Stream<List<FavoriteModel>> getFavItemsStream(String userId) {
  //   final response =  http.get(Uri.parse('$backendUrl/favorites/$userId'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => FavoriteModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load favorite items');
  //   }
  // }
  //
  // @override
  // Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
  //   return FirebaseFirestore.instance
  //       .collection('products')
  //       .where(FieldPath.documentId, whereIn: favoriteIds)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //       .map((doc) => ProductItemModel.fromJson(doc.data()))
  //       .toList());
  // }
}
