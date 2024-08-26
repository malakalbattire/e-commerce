import 'package:e_commerce_app_flutter/provider/category_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/category_widgets%20/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTabView extends StatefulWidget {
  const CategoryTabView({super.key});

  @override
  _CategoryTabViewState createState() => _CategoryTabViewState();
}

class _CategoryTabViewState extends State<CategoryTabView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryProvider.categories.isEmpty
              ? const Center(child: Text('No categories available'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (ctx, i) {
                    final category = categoryProvider.categories[i];
                    return CategoryItemWidget(
                      name: category.name,
                      imgUrl: category.imgUrl,
                    );
                  },
                ),
    );
  }
}
