import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:flutter/foundation.dart';

abstract class AddressServices {
  Future<void> addAddress(AddressModel addressModel);
  Future<void> removeAddress(String addressId);
  Future<List<AddressModel>> getAddressItems();
  Future<AddressModel> getAddressById(String addressId);
}

class AddressServicesImpl implements AddressServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<void> addAddress(AddressModel addressModel) async {
    final currentUser = await authServices.getUser();
    return await firestore.setData(
      path: ApiPath.addAddress(currentUser!.uid, addressModel.id),
      data: addressModel.toMap(),
    );
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
  Future<List<AddressModel>> getAddressItems() async {
    final currentUser = await authServices.getUser();
    final path = ApiPath.addAddressItems(currentUser!.uid);

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
