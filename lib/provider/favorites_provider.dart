import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/favorites_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  List<FavoriteModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';
  final FavServicesImpl favServices = FavServicesImpl();
  List<FavoriteModel> _favItems = [];
  IO.Socket? socket;

  final AuthServices authServices = AuthServicesImpl();

  ProductItemModel? get selectedProduct => _selectedProduct;
  List<FavoriteModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;
  List<FavoriteModel> get favItems => _favItems;

  FavoritesProvider() {
    _listenToAuthChanges();
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

    socket?.on('favoriteAdded', (data) {
      print('Favorite added via socket: $data');
      final newFavorite = FavoriteModel.fromJson(data);
      _favItems.add(newFavorite);
      _favoritesProducts.add(newFavorite);
      notifyListeners();
    });

    socket?.on('favoriteRemoved', (data) {
      print('Favorite removed via socket: $data');
      final productId = data['product_id'] as String;
      _favItems.removeWhere((fav) => fav.productId == productId);
      _favoritesProducts.removeWhere((fav) => fav.productId == productId);
      notifyListeners();
    });

    socket?.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  void _listenToAuthChanges() async {
    final currentUser = await authServices.getUser();
    if (currentUser == null) {
      _clearFavorites();
    } else {
      subscribeToFavorites(currentUser.id);
    }
  }

  Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
    return favServices.getProductStream(favoriteIds);
  }

  void _clearFavorites() {
    _favItems.clear();
    _favoritesProducts.clear();
    notifyListeners();
  }

  void subscribeToFavorites(String userId) {
    _state = FavoritesState.loading;
    notifyListeners();

    favServices.getFavItemsStream(userId).listen((favorites) async {
      List<FavoriteModel> updatedFavorites = [];

      for (var fav in favorites) {
        try {
          updatedFavorites.add(fav);
          if (kDebugMode) {
            print('Updated favorites: $fav');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error checking product existence: $e');
          }
        }
      }

      _favoritesProducts = updatedFavorites;
      _favItems = updatedFavorites;
      _state = updatedFavorites.isNotEmpty
          ? FavoritesState.loaded
          : FavoritesState.error;
      if (updatedFavorites.isEmpty) {
        _errorMessage = 'No favorites found.';
      }
      notifyListeners();
    }, onError: (error) {
      _state = FavoritesState.error;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  Future<void> addToFav(String productId) async {
    try {
      final currentUser = await authServices.getUser();

      if (currentUser == null) return;

      final existingFav =
          _favItems.firstWhereOrNull((fav) => fav.id == productId);

      if (existingFav != null) {
        await favServices.removeFromFav(productId);
        _favItems.removeWhere((fav) => fav.id == productId);
      } else {
        final selectedProduct = await favServices.getProductDetails(productId);
        final favItem = FavoriteModel(
          id: productId,
          name: selectedProduct.name,
          imgUrl: selectedProduct.imgUrl,
          isFavorite: true,
          description: selectedProduct.description,
          price: selectedProduct.price,
          category: selectedProduct.category,
          productId: productId,
          userId: currentUser.id,
        );
        await favServices.addToFav(favItem);
        _favItems.add(favItem);
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeFromFav(String productId) async {
    try {
      final currentUser = await authServices.getUser();
      if (currentUser != null) {
        await favServices.removeFromFav(productId);
        _favItems = await favServices.getFavItems(currentUser.id);
      } else {
        _favItems.clear();
      }
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = FavoritesState.error;
      notifyListeners();
    }
  }

  Future<void> getProductDetails(String id) async {
    try {
      final result = await favServices.getProductDetails(id);
      _selectedProduct = result;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<ProductItemModel> getInStockProduct(String productId) {
    return favServices.getProductDetails(productId);
  }

  bool isFavorite(String productId) {
    return _favItems.any((fav) => fav.id == productId);
  }
}
