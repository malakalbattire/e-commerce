import 'package:e_commerce_app_flutter/models/add_to_cart_model.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> getCartItems();
}

class CartServicesImpl implements CartServices {
  final firestore = FirestoreServices.instance;
  final authServices = AuthServicesImpl();

  @override
  Future<List<AddToCartModel>> getCartItems() async {
    final currentUser = await authServices.getUser();
    return await firestore.getCollection(
      path: ApiPath.addToCartItems(currentUser!.uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data, documentId),
    );
  }
}
