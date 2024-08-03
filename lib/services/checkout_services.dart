import 'package:e_commerce_app_flutter/models/checkout_model/checkout_model.dart';

class CheckoutServicesImpl implements CheckoutServices {
  @override
  Future<void> processCheckout(CheckoutModel checkoutModel) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}

abstract class CheckoutServices {
  Future<void> processCheckout(CheckoutModel checkoutModel);
}
