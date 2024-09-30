import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/add_payment_card_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PaymentState { initial, loading, loaded, error }

class CardPaymentProvider with ChangeNotifier {
  List<PaymentModel> _paymentItems = [];
  PaymentState _state = PaymentState.initial;
  String _errorMessage = '';
  final paymentServices = PaymentServicesImpl();
  String? _selectedPaymentMethodId;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  List<PaymentModel> get paymentItems => _paymentItems;
  PaymentState get state => _state;
  String get errorMessage => _errorMessage;
  String? get selectedPaymentMethodId => _selectedPaymentMethodId;

  Future<void> loadPaymentData(String userId) async {
    _state = PaymentState.loading;
    notifyListeners();
    try {
      final fetchedPayments = await paymentServices.getPaymentItems(userId);
      if (fetchedPayments.isEmpty) {
        _paymentItems = [];
        _state = PaymentState.loaded;
      } else {
        _paymentItems = fetchedPayments;
        _state = PaymentState.loaded;
      }
    } catch (error) {
      if (error.toString().contains("Not Found")) {
        _paymentItems = [];
        _state = PaymentState.loaded;
      } else {
        _state = PaymentState.error;
        _errorMessage = error.toString();
      }
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

  Future<void> submitCard({
    required String cardNumber,
    required String expiryDate,
    required String cvvCode,
    required String userId,
    required BuildContext context,
  }) async {
    final payment = PaymentModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvvCode: cvvCode,
      userId: userId,
    );

    await addPayment(payment);

    if (state == PaymentState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> clearPaymentCards() async {
    try {
      _paymentItems.clear();
      _state = PaymentState.initial;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = PaymentState.error;
      notifyListeners();
    }
  }

  void choosePayment(String paymentMethodId) {
    _selectedPaymentMethodId = paymentMethodId;
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

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}
