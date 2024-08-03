import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/product_item_model/product_item_model.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductItemModel> _searchResults = [];

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    final products = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ProductItemModel.fromMap(data, doc.id);
    }).toList();

    setState(() {
      _searchResults = products;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: CachedNetworkImage(
                    imageUrl: product.imgUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.productDetails,
                      arguments: product.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
