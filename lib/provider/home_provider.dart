import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/home_carousel_model.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/home_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum HomeState { initial, loading, loaded, error }

class HomeProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServicesImpl();
  HomeState _state = HomeState.initial;
  List<HomeCarouselModel> _carouselItems = [];
  List<ProductItemModel> _products = [];
  String _errorMessage = '';
  late IO.Socket _socket;
  bool _isSocketInitialized = false;

  HomeState get state => _state;
  List<HomeCarouselModel> get carouselItems => _carouselItems;
  List<ProductItemModel> get products => _products;
  String get errorMessage => _errorMessage;

  HomeProvider() {
    _initializeSocket();
  }

  void _initializeSocket() {
    if (_isSocketInitialized) return;
    _isSocketInitialized = true;

    _socket = IO.io(BackendUrl.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      if (kDebugMode) {
        print('Connected to socket server');
      }
    });

    _socket.on('productAdded', (data) {
      final newProduct = ProductItemModel.fromMap(data, data['id']);
      _products.add(newProduct);
      notifyListeners();
    });

    _socket.on('productUpdated', (data) {
      final updatedProduct = ProductItemModel.fromMap(data, data['id']);
      final index = _products.indexWhere((product) => product.id == data['id']);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    });

    _socket.on('productDeleted', (data) {
      _products.removeWhere((product) => product.id == data['id']);
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('Disconnected from socket server');
      }
    });
  }

  Stream<List<ProductItemModel>> getProductsStream() {
    return _homeServices.getProductsStream().handleError((error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
      notifyListeners();
    });
  }

  Future<void> loadHomeData() async {
    _state = HomeState.loading;
    notifyListeners();
    print('Loading home data...');

    try {
      _carouselItems = dummyCarouselItems;
      print('Carousel items set');

      _products = await _homeServices.getProducts();
      _state = HomeState.loaded;
      print('Home data loaded successfully');
    } catch (error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
      print('Error in loadHomeData: $_errorMessage');
    }

    notifyListeners();
  }

  Stream<List<ProductItemModel>> get productsStream {
    return _homeServices.getProductsStream().handleError((error) {
      _errorMessage = error.toString();
      _state = HomeState.error;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
