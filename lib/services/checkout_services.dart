import 'package:e_commerce_app_flutter/models/checkout_model/checkout_model.dart';

class CheckoutServicesImpl implements CheckoutServices {
  @override
  Future<void> processCheckout(CheckoutModel checkoutModel) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    // Add your actual checkout logic here, e.g., call a REST API
  }
}

abstract class CheckoutServices {
  Future<void> processCheckout(CheckoutModel checkoutModel);
}
