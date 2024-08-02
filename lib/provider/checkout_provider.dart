import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/checkout_model/checkout_model.dart';
import 'package:e_commerce_app_flutter/services/checkout_services.dart';

enum CheckoutState { initial, loading, success, error }

class CheckoutProvider with ChangeNotifier {
  CheckoutState _state = CheckoutState.initial;
  String _errorMessage = '';
  final CheckoutServices _checkoutServices = CheckoutServicesImpl();

  CheckoutState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> checkout(CheckoutModel checkoutModel) async {
    _state = CheckoutState.loading;
    notifyListeners();

    try {
      await _checkoutServices.processCheckout(checkoutModel);
      _state = CheckoutState.success;
    } catch (error) {
      _state = CheckoutState.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }

  void resetState() {
    _state = CheckoutState.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
