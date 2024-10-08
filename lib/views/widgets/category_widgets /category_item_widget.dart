import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final String name;
  final String imgUrl;

  CategoryItemWidget({required this.name, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final categoryProvider =
            Provider.of<CategoryProvider>(context, listen: false);
        categoryProvider.selectCategory(context, name);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imgUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
