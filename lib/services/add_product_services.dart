import 'dart:io';
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AddProductServices {
  Future<void> addProduct(AddProductModel productModel);
  Future<String> uploadImageToStorage(File image);
}

class AddProductServicesImpl implements AddProductServices {
  final firestore = FirestoreServices.instance;

  @override
  Future<void> addProduct(AddProductModel productModel) async {
    return await firestore.setData(
      path: ApiPath.product(productModel.id),
      data: productModel.toMap(),
    );
  }

  @override
  Future<String> uploadImageToStorage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('productsImg/$fileName');

    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }
}
