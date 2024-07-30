import 'package:e_commerce_app_flutter/models/address_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class AddressServices {
  Future<void> addAddress(AddressModel addressModel);
  Future<void> removeAddress(String addressId);
  Future<List<AddressModel>> getAddressItems();
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
  Future<void> removeAddress(String addressId) async {
    final currentUser = await authServices.getUser();
    await firestore.deleteData(
      path: ApiPath.addAddress(currentUser!.uid, addressId),
    );
  }

  @override
  Future<List<AddressModel>> getAddressItems() async {
    final currentUser = await authServices.getUser();
    return await firestore.getCollection(
      path: ApiPath.addAddressItems(currentUser!.uid),
      builder: (data, documentId) => AddressModel.fromMap(data),
    );
  }
}
