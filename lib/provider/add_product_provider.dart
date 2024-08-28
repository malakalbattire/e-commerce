import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:e_commerce_app_flutter/services/add_product_services.dart';

enum AddProductState { initial, loading, loaded, error }

class AddProductProvider with ChangeNotifier {
  final addProductServices = AddProductServicesImpl();
  AddProductState _state = AddProductState.initial;
  String _errorMessage = '';
  bool _isSubmitting = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AddProductState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
}
