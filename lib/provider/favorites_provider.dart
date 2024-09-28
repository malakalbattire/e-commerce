import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/favorites_services.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

// enum FavoritesState { initial, loading, loaded, error }
//
// class FavoritesProvider with ChangeNotifier {
//   ProductItemModel? _selectedProduct;
//   List<FavoriteModel> _favoritesProducts = [];
//   FavoritesState _state = FavoritesState.initial;
//   String _errorMessage = '';
//   final FavServicesImpl favServices = FavServicesImpl();
//   List<FavoriteModel> _favItems = [];
//
//   ProductItemModel? get selectedProduct => _selectedProduct;
//   List<FavoriteModel> get favoritesProducts => _favoritesProducts;
//   FavoritesState get state => _state;
//   String get errorMessage => _errorMessage;
//   List<FavoriteModel> get favItems => _favItems;
//
//   FavoritesProvider() {
//     _listenToAuthChanges();
//   }
//
//   void _listenToAuthChanges() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         _clearFavorites();
//       } else {
//         subscribeToFavorites(user.uid);
//       }
//     });
//   }
//
//   Stream<List<ProductItemModel>> getProductStream(List<String> favoriteIds) {
//     return favServices.getProductStream(favoriteIds);
//   }
//
//   void _clearFavorites() {
//     _favItems.clear();
//     _favoritesProducts.clear();
//     notifyListeners();
//   }
//
//   void subscribeToFavorites(String userId) {
//     _state = FavoritesState.loading;
//     notifyListeners();
//
//     favServices.getFavItemsStream(userId).listen((favorites) async {
//       List<FavoriteModel> updatedFavorites = [];
//
//       for (var fav in favorites) {
//         try {
//           updatedFavorites.add(fav);
//           print('Updated favorites: $fav');
//         } catch (e) {
//           if (kDebugMode) {
//             print('Error checking product existence: $e');
//           }
//         }
//       }
//
//       _favoritesProducts = updatedFavorites;
//       _favItems = updatedFavorites;
//       _state = updatedFavorites.isNotEmpty
//           ? FavoritesState.loaded
//           : FavoritesState.error;
//       if (updatedFavorites.isEmpty) {
//         _errorMessage = 'No favorites found.';
//       }
//       notifyListeners();
//     }, onError: (error) {
//       _state = FavoritesState.error;
//       _errorMessage = error.toString();
//       notifyListeners();
//     });
//   }
//
//   Future<void> addToFav(String productId) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//
//       final existingFav =
//           _favItems.firstWhereOrNull((fav) => fav.id == productId);
//
//       if (user == null) return;
//
//       if (existingFav != null) {
//         await favServices.removeFromFav(productId);
//         _favItems.removeWhere((fav) => fav.id == productId);
//       } else {
//         final selectedProduct = await favServices.getProductDetails(productId);
//         final favItem = FavoriteModel(
//           id: productId,
//           name: selectedProduct.name,
//           imgUrl: selectedProduct.imgUrl,
//           isFavorite: true,
//           description: selectedProduct.description,
//           price: selectedProduct.price,
//           category: selectedProduct.category,
//           productId: productId,
//           userId: user.uid,
//         );
//         await favServices.addToFav(favItem);
//         _favItems.add(favItem);
//       }
//
//       notifyListeners();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   Future<void> removeFromFav(String productId) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await favServices.removeFromFav(productId);
//         _favItems = await favServices.getFavItems(user.uid);
//       } else {
//         _favItems.clear();
//       }
//       notifyListeners();
//     } catch (error) {
//       _errorMessage = error.toString();
//       _state = FavoritesState.error;
//       notifyListeners();
//     }
//   }
//
//   Future<void> getProductDetails(String id) async {
//     try {
//       final result = await favServices.getProductDetails(id);
//       _selectedProduct = result;
//       notifyListeners();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   Future<ProductItemModel> getInStockProduct(String productId) {
//     return favServices.getProductDetails(productId);
//   }
//
//   bool isFavorite(String productId) {
//     return _favItems.any((fav) => fav.id == productId);
//   }
// }
enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  List<FavoriteModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';
  final FavServicesImpl favServices = FavServicesImpl();
  List<FavoriteModel> _favItems = [];

  final AuthServices authServices = AuthServicesImpl(); // Use AuthServices

  ProductItemModel? get selectedProduct => _selectedProduct;
  List<FavoriteModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;
  List<FavoriteModel> get favItems => _favItems;

  FavoritesProvider() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() async {
    final currentUser =
        await authServices.getUser(); // Fetch user data from MySQL
    if (currentUser == null) {
      _clearFavorites();
    } else {
      subscribeToFavorites(currentUser.id!); // Use the user ID
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
          print('Updated favorites: $fav');
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
      final currentUser =
          await authServices.getUser(); // Use MySQL-based user fetching

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
          userId: currentUser.id, // Use the user ID from MySQL
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
      final currentUser = await authServices.getUser(); // Fetch user from MySQL
      if (currentUser != null) {
        await favServices.removeFromFav(productId);
        _favItems = await favServices.getFavItems(currentUser.id!);
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
