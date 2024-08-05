import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/add_payment_card_services.dart';
import 'package:flutter/foundation.dart';

enum PaymentState { initial, loading, loaded, error }

class CardPaymentProvider with ChangeNotifier {
  List<PaymentModel> _paymentItems = [];
  PaymentState _state = PaymentState.initial;
  String _errorMessage = '';
  final paymentServices = PaymentServicesImpl();
  String? _selectedPaymentId;

  List<PaymentModel> get paymentItems => _paymentItems;
  PaymentState get state => _state;
  String get errorMessage => _errorMessage;
  String? get selectedPaymentId => _selectedPaymentId;

  Future<void> loadPaymentData() async {
    _state = PaymentState.loading;
    notifyListeners();
    try {
      final fetchedPayments = await paymentServices.getPaymentItems();
      _paymentItems = fetchedPayments;
      _state = PaymentState.loaded;
    } catch (error) {
      _state = PaymentState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<void> addPayment(PaymentModel paymentModel) async {
    try {
      await paymentServices.addPayment(paymentModel);
      _paymentItems.add(paymentModel);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = PaymentState.error;
      notifyListeners();
    }
  }

  // Future<void> updatePayment(PaymentModel paymentModel) async {
  //   try {
  //     await paymentServices.updatePayment(paymentModel);
  //     final index =
  //         _paymentItems.indexWhere((payment) => payment.id == paymentModel.id);
  //     if (index != -1) {
  //       _paymentItems[index] = paymentModel;
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     _errorMessage = error.toString();
  //     _state = PaymentState.error;
  //     notifyListeners();
  //   }
  // }

  void choosePayment(String paymentId) {
    _selectedPaymentId = paymentId;
    notifyListeners();
  }

  Future<void> removePayment(String paymentId) async {
    try {
      await paymentServices.removePayment(paymentId);
      _paymentItems.removeWhere((payment) => payment.id == paymentId);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = PaymentState.error;
      notifyListeners();
    }
  }
}
