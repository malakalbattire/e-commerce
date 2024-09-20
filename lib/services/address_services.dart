import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<AddressModel> getAddressById(String addressId);
}

class AddressServicesImpl implements AddressServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();
  final String backendUrl = 'http://192.168.88.10:3000';

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
  Future<AddressModel> getAddressById(String addressId) async {
    final doc = await FirebaseFirestore.instance
        .collection('address')
        .doc(addressId)
        .get();
    if (doc.exists) {
      return AddressModel.fromMap(doc.data()!, doc.id);
    } else {
      throw Exception('Address not found');
    }
  }

  @override
  Future<void> removeAddress(String addressId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addAddress(currentUser!.uid, addressId),
    );
  }

  @override
  Future<List<AddressModel>> getAddressItems(String userId) async {
    final path = ApiPath.addAddressItems(userId);

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
}
