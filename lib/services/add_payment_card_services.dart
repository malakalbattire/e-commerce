import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class PaymentServices {
  Future<void> addPayment(PaymentModel paymentModel);
  Future<void> removePayment(String paymentId);
  Future<List<PaymentModel>> getPaymentItems(String userId);
}

class PaymentServicesImpl implements PaymentServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();
  final String backendUrl = 'http://192.168.88.2:3000';

  @override
  Future<void> addPayment(PaymentModel paymentModel) async {
    final url = Uri.parse('$backendUrl/cards');
    final body = json.encode(paymentModel.toMap());
    print("Sending request to $url with body: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode != 201) {
      print("Response: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to add payment card');
    }
  }

  @override
  Future<void> removePayment(String paymentId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addPaymentCard(currentUser!.uid, paymentId),
    );
  }

  @override
  Future<List<PaymentModel>> getPaymentItems(String userId) async {
    try {
      final url = Uri.parse('$backendUrl/cards/$userId');
      print('Fetching payment cards from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> cardsItemsJson =
            json.decode(response.body) as List<dynamic>;
        print('Decoded payment cards items JSON: $cardsItemsJson');

        return cardsItemsJson
            .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('Failed to load payment cards items: ${response.body}');
        throw Exception(
            'Failed to load payment cards items: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching payment cards items: $e');
      throw Exception('Error fetching payment cards items: $e');
    }
  }
}
