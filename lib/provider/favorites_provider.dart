import 'package:e_commerce_app_flutter/models/favorite_model.dart';
import 'package:e_commerce_app_flutter/services/favorites_services.dart';
import 'package:flutter/foundation.dart';
import '../../models/product_item_model.dart';

enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  List<FavoriteModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';
  final favServices = FavServicesIpl();
  final List<FavoriteModel> _favItems = [];

  ProductItemModel? get selectedProduct => _selectedProduct;
  List<FavoriteModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;
  List<FavoriteModel> get favItems => _favItems;

  Future<void> loadFavData() async {
    _state = FavoritesState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _favoritesProducts = await favServices.getFavItems();
      _state = FavoritesState.loaded;
    } catch (error) {
      _state = FavoritesState.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future<void> addToFav(String productId) async {
    try {
      final selectedProduct = await favServices.getProductDetails(productId);
      if (selectedProduct != null) {
        final favItem = FavoriteModel(
          id: productId,
          name: selectedProduct.name,
          imgUrl: selectedProduct.imgUrl,
          isFavorite:
              true, // Assuming this should be true when adding to favorites
          description: selectedProduct.description,
          price: selectedProduct.price,
          category: selectedProduct.category,
        );
        await favServices.addToFav(favItem);
        _favItems.add(favItem);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getProductDetails(String id) async {
    try {
      final result = await favServices.getProductDetails(id);
      _selectedProduct = result;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
