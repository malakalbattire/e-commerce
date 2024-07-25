import 'package:flutter/foundation.dart';
import '../../models/product_item_model.dart';

enum FavoritesState { initial, loading, loaded, error }

class FavoritesProvider with ChangeNotifier {
  List<ProductItemModel> _favoritesProducts = [];
  FavoritesState _state = FavoritesState.initial;
  String _errorMessage = '';

  List<ProductItemModel> get favoritesProducts => _favoritesProducts;
  FavoritesState get state => _state;
  String get errorMessage => _errorMessage;

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
}
