import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:flutter/foundation.dart';

enum PaymentState { initial, loading, loaded, error }

class PaymentProvider with ChangeNotifier {
  List<ProductItemModel> _cartItems = [];
  PaymentState _state = PaymentState.initial;
  String _errorMessage = '';
  double _subtotal = 0.0;
  final double _shippingCost = 10.0;
  String? _selectedPaymentMethodId;
  double _total = 0.0;

  List<ProductItemModel> get cartItems => _cartItems;
  PaymentState get state => _state;
  String get errorMessage => _errorMessage;
  double get subtotal => _subtotal;
  double get total => _total;
  String? get selectedPaymentMethodId => _selectedPaymentMethodId;

  void loadPaymentData() async {
    _state = PaymentState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _cartItems = dummyProducts.where((item) => item.isAddedToCart).toList();
      _calculateTotals();
      _state = PaymentState.loaded;
    } catch (error) {
      _state = PaymentState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }

  void _calculateTotals() {
    _subtotal =
        _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    _total = _subtotal + _shippingCost;
  }

  void choosePaymentMethod(String paymentMethodId) {
    _selectedPaymentMethodId = paymentMethodId;
    notifyListeners();
  }
}
