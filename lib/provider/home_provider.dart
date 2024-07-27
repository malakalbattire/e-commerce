// import 'package:flutter/foundation.dart';
// import '../../models/home_carousel_model.dart';
// import '../../models/product_item_model.dart';
// import 'package:e_commerce_app_flutter/services/home_services.dart';
//
// enum HomeState { initial, loading, loaded, error }
//
// class HomeProvider with ChangeNotifier {
//   List<HomeCarouselModel> _carouselItems = [];
//   List<ProductItemModel> _products = [];
//   HomeState _state = HomeState.initial;
//   String _errorMessage = '';
//
//   List<HomeCarouselModel> get carouselItems => _carouselItems;
//   List<ProductItemModel> get products => _products;
//   HomeState get state => _state;
//   String get errorMessage => _errorMessage;
//
//   final homeServices = HomeServicesImpl();
//
//   void loadHomeData() async {
//     _state = HomeState.loading;
//     notifyListeners();
//
//     try {
//       await Future.delayed(const Duration(seconds: 2));
//
//       final carouselItems = await homeServices.getCarousel();
//       _carouselItems = carouselItems;
//       print(carouselItems);
//       //_products = dummyProducts;
//       _state = HomeState.loaded;
//     } catch (error) {
//       _state = HomeState.error;
//       _errorMessage = error.toString();
//     }
//
//     notifyListeners();
//   }
//
//   Future<void> getHomeData() async {
//     try {
//       _state = HomeState.loading;
//       notifyListeners();
//
//       final items = await homeServices.getProducts();
//       _products = items;
//       _state = HomeState.loaded;
//     } catch (error) {
//       _state = HomeState.error;
//       _errorMessage = error.toString();
//     }
//
//     notifyListeners();
//   }
//
//   Future<void> getProductsStream() async {
//     try {
//       _state = HomeState.loading;
//       notifyListeners();
//
//       final productsStream = await homeServices.getProductsStream();
//
//       productsStream.listen((event) {
//         _products = event;
//         notifyListeners();
//       });
//
//       _state = HomeState.loaded;
//     } catch (error) {
//       _state = HomeState.error;
//       _errorMessage = error.toString();
//     }
//
//     notifyListeners();
//   }
//
//   Future<void> addProduct(ProductItemModel product) async {
//     await homeServices.addProduct(product);
//     notifyListeners();
//   }
//
//   Future<void> deleteProduct(String id) async {
//     await homeServices.deleteProduct(id);
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/home_carousel_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model.dart';
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
      _carouselItems = await _homeServices.getCarousel();
      print('Carousel Items: $_carouselItems'); // Debug print
      _products = await _homeServices.getProducts();
      print('Products: $_products'); // Debug print
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
        print('Streamed Products: $_products'); // Debug print
        notifyListeners();
      });
    } catch (error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
      notifyListeners();
    }
  }
}
