import 'package:e_commerce_app_flutter/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/checkout_services.dart';

enum CheckoutState { initial, loading, success, error }

class CheckoutProvider with ChangeNotifier {
  final CheckoutServices _checkoutServices = CheckoutServicesImpl();
  final CartServicesImpl cartServices = CartServicesImpl();

  List<AddToCartModel> _cartItems = [];
  List<AddressModel> _addressItems = [];
  List<PaymentModel> _paymentItems = [];
  CheckoutState _state = CheckoutState.initial;

  List<AddToCartModel> get cartItems => _cartItems;
  List<AddressModel> get addressItems => _addressItems;
  List<PaymentModel> get paymentItems => _paymentItems;
  CheckoutState get state => _state;

  void _setState(CheckoutState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadCartItems() async {
    _setState(CheckoutState.loading);
    try {
      _cartItems = await cartServices.getCartItems();
      _setState(CheckoutState.success);
    } catch (e) {
      _setState(CheckoutState.error);
    }
  }

  Future<void> loadAddressItems() async {
    _setState(CheckoutState.loading);
    try {
      _addressItems = await _checkoutServices.getAddressItems();
      _setState(CheckoutState.success);
    } catch (e) {
      _setState(CheckoutState.error);
    }
  }

  Future<void> loadPaymentItems() async {
    _setState(CheckoutState.loading);
    try {
      _paymentItems = await _checkoutServices.getPaymentItems();
      _setState(CheckoutState.success);
    } catch (e) {
      _setState(CheckoutState.error);
    }
  }

  void clear() {
    _cartItems = [];
    _addressItems = [];
    _paymentItems = [];
    _setState(CheckoutState.initial);
  }
}
