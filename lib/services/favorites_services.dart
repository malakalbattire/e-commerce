import 'dart:convert';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:http/http.dart' as http;
import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

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
  IO.Socket? socket;

  final StreamController<List<FavoriteModel>> _favoritesController =
      StreamController<List<FavoriteModel>>.broadcast();

  final StreamController<List<ProductItemModel>> _productController =
      StreamController<List<ProductItemModel>>.broadcast();

  FavServicesImpl() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io('${BackendUrl.url}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      print('Connected to Socket.IO server');
    });

    socket?.on('favoriteAdded', (data) async {
      print('Favorite added: $data');
      final userId = await getCurrentUserId();
      _fetchAndEmitFavorites(userId);
    });

    socket?.on('favoriteRemoved', (data) async {
      print('Favorite removed: $data');
      final userId = await getCurrentUserId();
      _fetchAndEmitFavorites(userId);
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

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
      print('Added to favorites successfully');

      socket?.emit('favoriteAdded', {
        'user_id': userId,
        'product_id': addToFavModel.productId,
        'name': addToFavModel.name,
        'imgUrl': addToFavModel.imgUrl,
        'description': addToFavModel.description,
        'price': addToFavModel.price,
        'category': addToFavModel.category,
      });
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
      print('Removed from favorites successfully');

      socket?.emit('favoriteRemoved', {
        'user_id': userId,
        'product_id': productId,
      });
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

  Future<void> _fetchAndEmitFavorites(String userId) async {
    final favorites = await getFavItems(userId);
    _favoritesController.sink.add(favorites);
  }

  @override
  Future<List<FavoriteModel>> getFavItems(String userId) async {
    try {
      final url = Uri.parse('${BackendUrl.url}/favorites/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> favoriteItemsJson =
            json.decode(response.body) as List<dynamic>;
        return favoriteItemsJson
            .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load favorite items');
      }
    } catch (e) {
      throw Exception('Error fetching favorite items: $e');
    }
  }

  @override
  Stream<List<FavoriteModel>> getFavItemsStream(String userId) {
    _fetchAndEmitFavorites(userId);
    return _favoritesController.stream;
  }

  @override
  Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
    _fetchAndEmitProducts(favoriteIds);
    return _productController.stream;
  }

  Future<void> _fetchAndEmitProducts(List<String> favoriteIds) async {
    final List<ProductItemModel> products = [];
    for (String id in favoriteIds) {
      final product = await getProductDetails(id);
      products.add(product);
    }
    _productController.sink.add(products);
  }

  void dispose() {
    _favoritesController.close();
    _productController.close();
  }
}
