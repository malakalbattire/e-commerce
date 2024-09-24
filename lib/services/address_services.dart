import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AddressServices {
  Future<void> addAddress(AddressModel addressModel);
  Future<void> removeAddress(String addressId);
  Future<List<AddressModel>> getAddressItems(String userId);
}

class AddressServicesImpl implements AddressServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();
  final String backendUrl = 'http://192.168.88.5:3000';

  @override
  Future<void> addAddress(AddressModel addressModel) async {
    final currentUser = await authServices.getUser();

    final url = Uri.parse('$backendUrl/addresses');

    final body = {
      'id': addressModel.id,
      'firstName': addressModel.firstName,
      'lastName': addressModel.lastName,
      'countryName': addressModel.countryName,
      'cityName': addressModel.cityName,
      'phoneNumber': addressModel.phoneNumber,
      'isSelected': addressModel.isSelected,
      'userId': currentUser!.uid,
    };
    print("userId in services when add cards${currentUser.uid}");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        print('Address added successfully: ${response.body}');
      } else {
        throw Exception('Failed to add address: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error adding address: $e');
      throw Exception('Error adding address: $e');
    }
  }

  @override
  Future<void> removeAddress(String addressId) async {
    try {
      final currentUser = await authServices.getUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      final url = Uri.parse('$backendUrl/addresses/$addressId');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Address successfully removed.');
        }
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('Address not found.');
        }
      } else {
        if (kDebugMode) {
          print('Error removing address: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while removing address: $e');
      }
    }
  }

  @override
  Future<List<AddressModel>> getAddressItems(String userId) async {
    final url = Uri.parse('$backendUrl/addresses/$userId');

    try {
      print('Fetching payment cards from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((data) => AddressModel.fromMap(data, data['id']))
            .toList();
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print('No addresses found for userId: $userId');
        }
        return [];
      } else {
        if (kDebugMode) {
          print('Error fetching addresses: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching addresses: $e');
      }
      return [];
    }
  }
}
