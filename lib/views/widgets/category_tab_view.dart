import 'package:e_commerce_app_flutter/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoryProvider.state == CategoryState.initial) {
        categoryProvider.loadCategoryData();
      }
    });
    return SingleChildScrollView(
      child: Column(
        children: [
          if (categoryProvider.state == CategoryState.loading)
            const Center(child: CircularProgressIndicator())
          else if (categoryProvider.state == CategoryState.error)
            Text('Error: ${categoryProvider.errorMessage}')
          else ...[
            GestureDetector(
              onTap: () {
                print(dummyCategories.length);
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: dummyCategories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: dummyCategories[index].imgUrl,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
