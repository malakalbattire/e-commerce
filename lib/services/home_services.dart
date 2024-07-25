import 'package:e_commerce_app_flutter/models/product_item_model.dart';
//import 'package:e_commerce_app_flutter/services/firestore_services.dart';
//import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> getProducts();
}

// class HomeServicesImpl implements HomeServices {
//   final firestore = FirestoreServices.instance;
//
//   @override
//   Future<List<ProductItemModel>> getProducts() async {
//     return await firestore.getCollection<ProductItemModel>(
//         path: ApiPath.products(),
//         builder: (data, documentId) {
//           final productData = data as Map<String, dynamic>;
//           return ProductItemModel(
//             id: documentId,
//             name: productData['name'] as String,
//             imgUrl: productData['imgUrl'] as String,
//             price: productData['price'] as double,
//             category: productData['category'] as String,
//           );
//         });
//   }
// }
