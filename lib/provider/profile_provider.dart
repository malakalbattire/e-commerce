import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  final AuthServices authServices = AuthServicesImpl();
  bool isLoggedIn = false;
  bool isAdmin = false;

  Future<void> handleAuthState() async {
    isLoggedIn = await authServices.isLoggedIn();

    if (isLoggedIn) {
      isAdmin = await authServices.isAdmin();
    } else {
      isAdmin = false;
    }

    notifyListeners();
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await authServices.logout();
      await _clearUserData();
      isLoggedIn = false;
      isAdmin = false;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  Future<void> _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    notifyListeners();
  }
}
