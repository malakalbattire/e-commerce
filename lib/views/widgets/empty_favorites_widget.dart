import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';

class EmptyFavoriteWidget extends StatelessWidget {
  const EmptyFavoriteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 80, color: AppColors.gray),
          const SizedBox(height: 20),
          const Text('Your favorites is empty',
              style: TextStyle(fontSize: 18, color: AppColors.gray)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(AppRoutes.home);
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: Theme.of(context).primaryColor),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }
}
