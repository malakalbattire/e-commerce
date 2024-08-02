import 'package:e_commerce_app_flutter/models/payment_method_model/payment_method_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class PaymentMethodServices {
  Future<void> addPaymentMethod(PaymentMethodModel paymentMethodModel);
  Future<void> removePaymentMethod(String paymentMethodId);
  Future<List<PaymentMethodModel>> getPaymentMethodItems();
}

class PaymentServicesImpl implements PaymentMethodServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<void> addPaymentMethod(PaymentMethodModel paymentMethodModel) async {
    final currentUser = await authServices.getUser();
    return await firestore.setData(
      path: ApiPath.addPaymentMethod(currentUser!.uid, paymentMethodModel.id),
      data: paymentMethodModel.toMap(),
    );
  }

  @override
  Future<void> removePaymentMethod(String paymentMethodId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addPaymentMethod(currentUser!.uid, paymentMethodId),
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethodItems() async {
    final currentUser = await authServices.getUser();
    return await firestore.getCollection(
      path: ApiPath.addPaymentMethodItems(currentUser!.uid),
      builder: (data, documentId) => PaymentMethodModel.fromMap(data),
    );
  }
}
