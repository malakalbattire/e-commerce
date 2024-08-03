import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:flutter/foundation.dart';

abstract class PaymentServices {
  Future<void> addPayment(PaymentModel paymentModel);
  Future<void> removePayment(String paymentId);
  Future<List<PaymentModel>> getPaymentItems();
}

class PaymentServicesImpl implements PaymentServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<void> addPayment(PaymentModel paymentModel) async {
    final currentUser = await authServices.getUser();
    return await firestore.setData(
      path: ApiPath.addPaymentCard(currentUser!.uid, paymentModel.id),
      data: paymentModel.toMap(),
    );
  }

  @override
  Future<void> removePayment(String paymentId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addPaymentCard(currentUser!.uid, paymentId),
    );
  }

  @override
  Future<List<PaymentModel>> getPaymentItems() async {
    final currentUser = await authServices.getUser();
    final path = ApiPath.addPaymentCardItems(currentUser!.uid);

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
