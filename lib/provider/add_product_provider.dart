import 'dart:io';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:e_commerce_app_flutter/services/add_product_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum AddProductState { initial, loading, loaded, error }

class AddProductProvider with ChangeNotifier {
  final addProductServices = AddProductServicesImpl();
  AddProductState _state = AddProductState.initial;
  String _errorMessage = '';
  bool _isSubmitting = false;
  bool _isLoading = false;

  late IO.Socket _socket;

  AddProductProvider() {
    _initializeSocket();
  }

  AddProductState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _initializeSocket() {
    _socket = IO.io(BackendUrl.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      if (kDebugMode) {
        print('Connected to socket server');
      }
    });

    _socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('Disconnected from socket server');
      }
    });
  }

  Future<void> addProduct(AddProductModel product, File? imageFile) async {
    if (_isSubmitting) return;
    if (imageFile == null) {
      _errorMessage = 'No image selected';
      _state = AddProductState.error;
      notifyListeners();
      return;
    }

    _isSubmitting = true;
    _state = AddProductState.loading;
    notifyListeners();

    try {
      setLoading(true);

      final imageUrl = await addProductServices.uploadImageToStorage(imageFile);

      final productWithImage = product.copyWith(imgUrl: imageUrl);

      await addProductServices.addProduct(productWithImage);

      _socket.emit('productAdded', productWithImage.toMap());

      _state = AddProductState.loaded;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      _state = AddProductState.error;
    } finally {
      setLoading(false);
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
