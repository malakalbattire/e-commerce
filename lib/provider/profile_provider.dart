import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthServices authServices = AuthServicesImpl();
  bool isLoggedIn = false;
  bool isAdmin = false;

  Future<void> handleAuthState() async {
    final User? user = firebaseAuth.currentUser;
    if (user != null) {
      final bool adminStatus = await authServices.isAdmin();
      isLoggedIn = true;
      isAdmin = adminStatus;
    } else {
      isLoggedIn = false;
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
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Logout'),
                ),
                const Divider(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await firebaseAuth.signOut();
      isLoggedIn = false;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }
}
