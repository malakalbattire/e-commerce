import 'package:flutter/foundation.dart';
import '../../models/home_carousel_model.dart';
import '../../models/product_item_model.dart';

enum HomeState { initial, loading, loaded, error }

class HomeProvider with ChangeNotifier {
  List<HomeCarouselModel> _carouselItems = [];
  List<ProductItemModel> _products = [];
  HomeState _state = HomeState.initial;
  String _errorMessage = '';

  List<HomeCarouselModel> get carouselItems => _carouselItems;
  List<ProductItemModel> get products => _products;
  HomeState get state => _state;
  String get errorMessage => _errorMessage;

  void loadHomeData() async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _carouselItems = dummyCarouselItems;
      _products = dummyProducts;
      _state = HomeState.loaded;
    } catch (error) {
      _state = HomeState.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }
}
