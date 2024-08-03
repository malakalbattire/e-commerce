import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/home_carousel_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/home_services.dart';

enum HomeState { initial, loading, loaded, error }

class HomeProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServicesImpl();
  HomeState _state = HomeState.initial;
  List<HomeCarouselModel> _carouselItems = [];
  List<ProductItemModel> _products = [];
  String _errorMessage = '';

  HomeState get state => _state;
  List<HomeCarouselModel> get carouselItems => _carouselItems;
  List<ProductItemModel> get products => _products;
  String get errorMessage => _errorMessage;

  Future<void> loadHomeData() async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      _carouselItems = dummyCarouselItems;
      if (kDebugMode) {
        print('Carousel Items: $_carouselItems');
      }
      _products = await _homeServices.getProducts();
      _state = HomeState.loaded;
    } catch (error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
    }
    notifyListeners();
  }

  Stream<void> getProductsStream() async* {
    try {
      _homeServices.getProductsStream().listen((products) {
        _products = products;
        notifyListeners();
      });
    } catch (error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
      notifyListeners();
    }
  }
}
