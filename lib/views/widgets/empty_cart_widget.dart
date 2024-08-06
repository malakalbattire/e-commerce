import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.gray),
          const SizedBox(height: 20),
          const Text('Your cart is empty',
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
