import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> getProducts();
  Stream<List<ProductItemModel>> getProductsStream();
  Future<void> addProduct(ProductItemModel product);
  Future<void> deleteProduct(String id);
}

class HomeServicesImpl implements HomeServices {
  final firestore = FirestoreServices.instance;

  @override
  Future<List<ProductItemModel>> getProducts() async {
    return await firestore.getCollection<ProductItemModel>(
      path: ApiPath.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
  }

  // @override
  // Future<List<HomeCarouselModel>> getCarousel() async {
  //   return await firestore.getCollection<HomeCarouselModel>(
  //     path: ApiPath.carousel(),
  //     builder: (data, documentId) =>
  //         HomeCarouselModel.fromMap(data, documentId),
  //   );
  //   //print('Fetched Carousel Data: $carousels'); // Debug print
  //   //return carousels;
  // }

  @override
  Stream<List<ProductItemModel>> getProductsStream() {
    return firestore.collectionStream(
      path: ApiPath.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data, documentId),
    );
  }

  @override
  Future<void> addProduct(ProductItemModel product) async => await firestore
      .setData(path: ApiPath.product(product.id), data: product.toMap());

  @override
  Future<void> deleteProduct(String id) async =>
      await firestore.deleteData(path: ApiPath.product(id));
}
