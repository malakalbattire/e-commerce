import 'package:e_commerce_app_flutter/models/favorite_model/favorite_model.dart';
import 'package:e_commerce_app_flutter/services/favorites_services.dart';
import 'package:flutter/foundation.dart';
import '../models/product_item_model/product_item_model.dart';

enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  List<FavoriteModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';
  final favServices = FavServicesIpl();
  List<FavoriteModel> _favItems = [];

  ProductItemModel? get selectedProduct => _selectedProduct;
  List<FavoriteModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;
  List<FavoriteModel> get favItems => _favItems;

  void subscribeToFavorites() {
    _state = FavoritesState.loading;
    notifyListeners();

    favServices.getFavItemsStream().listen((favorites) {
      _favoritesProducts = favorites;
      _favItems = favorites;
      _state = FavoritesState.loaded;
      notifyListeners();
    }, onError: (error) {
      _state = FavoritesState.error;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  Future<void> addToFav(String productId) async {
    try {
      final existingFav = _favItems.firstWhere(
        (fav) => fav.id == productId,
        orElse: () => FavoriteModel(
          id: '',
          name: '',
          imgUrl: '',
          isFavorite: false,
          description: '',
          price: 0.0,
          category: '',
        ),
      );

      if (existingFav.id.isNotEmpty) {
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
      await favServices.removeFromFav(productId);
      _favItems = await favServices.getFavItems();
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

  bool isFavorite(String productId) {
    return _favItems.any((fav) => fav.id == productId);
  }
}
