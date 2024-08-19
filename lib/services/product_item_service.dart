import 'package:e_commerce_app_flutter/services/firestore_services.dart';

abstract class ProductItemService {
  Stream<String> getNameStream(String productId);
  Stream<String> getImgUrlStream(String productId);
  Stream<double> getPriceStream(String productId);
  Stream<String> getCategoryStream(String productId);
  Stream<int> getStockStream(String productId);
  Stream<String> getDescriptionStream(String productId);
  Future<void> deleteProduct(String productId);
}

class ProductItemServiceImpl implements ProductItemService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  @override
  Stream<String> getNameStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => data['name'] as String,
    );
  }

  @override
  Stream<String> getImgUrlStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => data['imgUrl'] as String,
    );
  }

  @override
  Stream<double> getPriceStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => (data['price'] as double),
    );
  }

  @override
  Stream<String> getCategoryStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => data['category'] as String,
    );
  }

  @override
  Stream<String> getDescriptionStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => data['description'] as String,
    );
  }

  @override
  Stream<int> getStockStream(String productId) {
    return _firestoreServices.documentStream(
      path: 'products/$productId',
      builder: (data, id) => data['inStock'] as int,
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _firestoreServices.deleteData(path: 'products/$productId');
  }
}
