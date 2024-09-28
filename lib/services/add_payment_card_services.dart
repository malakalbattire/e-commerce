import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
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

  @override
  Future<void> addPayment(PaymentModel paymentModel) async {
    final url = Uri.parse('${BackendUrl.url}/cards');
    final body = json.encode(paymentModel.toMap());
    if (kDebugMode) {
      print("Sending request to $url with body: $body");
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode != 201) {
      if (kDebugMode) {
        print("Response: ${response.statusCode} - ${response.body}");
      }
      throw Exception('Failed to add payment card');
    }
  }

  @override
  Future<void> removePayment(String paymentId) async {
    try {
      final currentUser = await authServices.getUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final url = Uri.parse('${BackendUrl.url}/cards/$paymentId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Payment card deleted successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete payment card: ${response.body}');
        }
        throw Exception(
            'Failed to delete payment card: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing payment card: $e');
      }
      throw Exception('Error removing payment card: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentItems(String userId) async {
    try {
      final url = Uri.parse('${BackendUrl.url}/cards/$userId');
      if (kDebugMode) {
        print('Fetching payment cards from: $url');
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> cardsItemsJson =
            json.decode(response.body) as List<dynamic>;
        if (kDebugMode) {
          print('Decoded payment cards items JSON: $cardsItemsJson');
        }

        return cardsItemsJson
            .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        if (kDebugMode) {
          print('Failed to load payment cards items: ${response.body}');
        }
        throw Exception(
            'Failed to load payment cards items: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching payment cards items: $e');
      }
      throw Exception('Error fetching payment cards items: $e');
    }
  }
}
