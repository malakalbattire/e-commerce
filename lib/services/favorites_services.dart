import 'dart:convert';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
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
  Future<String> getCurrentUserId();
}

class FavServicesImpl implements FavoritesServices {
  final authServices = AuthServicesImpl();
  @override
  Future<String> getCurrentUserId() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      throw Exception('No user is signed in.');
    }
    return currentUser.id;
  }

  @override
  Future<void> addToFav(FavoriteModel addToFavModel) async {
    final userId = await getCurrentUserId();

    final response = await http.post(
      Uri.parse('${BackendUrl.url}/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': addToFavModel.id,
        'user_id': userId,
        'product_id': addToFavModel.productId,
        'name': addToFavModel.name,
        'imgUrl': addToFavModel.imgUrl,
        'isFavorite': true,
        'description': addToFavModel.description,
        'price': addToFavModel.price,
        'category': addToFavModel.category,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add to favorites');
    } else {
      if (kDebugMode) {
        print('Added to favorites successfully');
      }
    }
  }

  @override
  Future<void> removeFromFav(String productId) async {
    final userId = await getCurrentUserId();
    final response = await http.post(
      Uri.parse('${BackendUrl.url}/favorites/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    } else {
      if (kDebugMode) {
        print('removed');
      }
    }
  }

  @override
  Future<ProductItemModel> getProductDetails(String id) async {
    final response =
        await http.get(Uri.parse('${BackendUrl.url}/products/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductItemModel.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Future<List<FavoriteModel>> getFavItems(String userId) async {
    try {
      final url = Uri.parse('${BackendUrl.url}/favorites/$userId');
      if (kDebugMode) {
        print('Fetching favorite items from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> favoriteItemsJson =
            json.decode(response.body) as List<dynamic>;
        if (kDebugMode) {
          print(
              'Decoded favorite items JSON====fav serv getFavItems: $favoriteItemsJson');
        }
        return favoriteItemsJson
            .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        if (kDebugMode) {
          print('Failed to load favorite items');
        }
        throw Exception(
            'Failed to load favorite items: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching favorite items: $e');
      }
      throw Exception('Error fetching favorite items: $e');
    }
  }

  @override
  Stream<List<FavoriteModel>> getFavItemsStream(String userId) {
    return Stream.periodic(Duration(seconds: 4), (_) async {
      try {
        final url = Uri.parse('${BackendUrl.url}/favorites/$userId');

        if (url == null) {
          throw Exception('Constructed URL is null');
        }

        if (kDebugMode) {
          if (kDebugMode) {
            print('Fetching favorite items from: $url');
          }
        }

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> favoriteItemsJson =
              json.decode(response.body) as List<dynamic>;
          if (kDebugMode) {
            print(
                '=====Decoded favorite items JSON=====fav serv getFavItemsStream: $favoriteItemsJson');
          }
          return favoriteItemsJson
              .map((json) =>
                  FavoriteModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              'Failed to load favorite items: ${response.reasonPhrase}');
        }
      } catch (e) {
        if (kDebugMode) {
          if (kDebugMode) {
            print('Error fetching favorite items: $e');
          }
        }
        throw Exception('Error fetching favorite items: $e');
      }
    }).asyncMap((event) => event);
  }

  @override
  Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
    return Stream.periodic(Duration(seconds: 30), (_) async {
      final List<ProductItemModel> products = [];
      for (String id in favoriteIds) {
        final response =
            await http.get(Uri.parse('${BackendUrl.url}/products/$id'));
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
}
