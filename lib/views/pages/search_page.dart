import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/provider/search_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          title: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return TextField(
                controller: searchProvider.searchController,
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
        body: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            final searchResults = searchProvider.searchResults;

            return searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                          ),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: product.imgUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            '\$${product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.productDetails,
                              arguments: product.id,
                            );
                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
