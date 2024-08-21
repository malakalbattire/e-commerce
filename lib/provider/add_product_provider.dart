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

  AddProductState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;

  Future<void> addProduct(
    String name,
    File? imageFile,
    double price,
    String description,
    String category,
    int inStock,
    // List<ProductColor> selectedColors,
    // List<ProductSize> selectedSizes,
  ) async {
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
      final imageUrl = await addProductServices.uploadImageToStorage(imageFile);

      final product = AddProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        imgUrl: imageUrl,
        price: price,
        description: description,
        category: category,
        // sizes: selectedSizes,
        inStock: inStock,
        // colors: selectedColors,
      );

      await addProductServices.addProduct(product);
      _state = AddProductState.loaded;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      _state = AddProductState.error;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
