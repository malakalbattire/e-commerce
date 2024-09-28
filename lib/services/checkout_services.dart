import 'package:e_commerce_app_flutter/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:flutter/foundation.dart';

abstract class CheckoutServices {
  Future<List<AddToCartModel>> getCartItems();
  Future<List<AddressModel>> getAddressItems();
  Future<List<PaymentModel>> getPaymentItems();
}

class CheckoutServicesImpl implements CheckoutServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<List<AddToCartModel>> getCartItems() async {
    final currentUser = await authServices.getUser();
    final userId = currentUser!.id;
    return await firestore.getCollection(
      path: ApiPath.addToCartItems(userId),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
    );
  }

  @override
  Future<List<AddressModel>> getAddressItems() async {
    final currentUser = await authServices.getUser();
    final path = ApiPath.addAddressItems(currentUser!.id);

    try {
      final addresses = await firestore.getCollection(
        path: path,
        builder: (data, documentId) {
          return AddressModel.fromMap(data, documentId);
        },
      );

      return addresses;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentItems() async {
    final currentUser = await authServices.getUser();
    final path = ApiPath.addPaymentCardItems(currentUser!.id);

    try {
      final payments = await firestore.getCollection(
        path: path,
        builder: (data, documentId) {
          return PaymentModel.fromMap(data, documentId);
        },
      );

      return payments;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
