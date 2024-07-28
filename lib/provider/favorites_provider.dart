import 'package:e_commerce_app_flutter/models/favorite_model.dart';
import 'package:e_commerce_app_flutter/services/favorites_services.dart';
import 'package:flutter/foundation.dart';
import '../../models/product_item_model.dart';

enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  ProductItemModel? _selectedProduct;
  List<ProductItemModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';
  final favServices = FavServicesIpl();
  final List<FavoriteModel> _favItems = [];

  ProductItemModel? get selectedProduct => _selectedProduct;
  List<ProductItemModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;
  List<FavoriteModel> get favItems => _favItems;

  void loadHomeData() async {
    _state = FavoritesState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _favoritesProducts =
          dummyProducts.where((item) => item.isFavorite).toList();

      _state = FavoritesState.loaded;
    } catch (error) {
      _state = FavoritesState.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future<void> addToFav(String productId) async {
    try {
      if (_selectedProduct != null) {
        final selectedProduct = await favServices.getProductDetails(productId);
        final favItem = FavoriteModel(
          id: productId,
          productId: productId,
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

  // Future<void> loadFavData() async {
  //   _state = FavoritesState.loading;
  //   notifyListeners();
  //
  //   try {
  //     await Future.delayed(const Duration(seconds: 2));
  //     _favItems = await favServices.g();
  //     _state = FavoritesState.loaded;
  //   } catch (error) {
  //     _state = FavoritesState.error;
  //     _errorMessage = error.toString();
  //   }
  //   notifyListeners();
  // }
}
