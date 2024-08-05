import 'package:e_commerce_app_flutter/provider/category_provider.dart';
import 'package:e_commerce_app_flutter/views/widgets/category_widgets%20/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60.0),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (ctx, i) => CategoryItemWidget(
          name: categoryProvider.categories[i].name,
          imgUrl: categoryProvider.categories[i].imgUrl,
        ),
      ),
    );
  }
}
