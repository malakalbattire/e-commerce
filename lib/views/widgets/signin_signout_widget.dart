import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SigninSignoutWidget extends StatelessWidget {
  const SigninSignoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 80, color: AppColors.gray),
          const Text('You are SignOut ',
              style: TextStyle(fontSize: 18, color: AppColors.gray)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: Theme.of(context).primaryColor),
            child: const Text('SignIn'),
          ),
        ],
      ),
    );
  }
}
