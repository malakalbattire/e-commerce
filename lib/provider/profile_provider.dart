import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';

// class ProfileProvider with ChangeNotifier {
//   final AuthServices authServices = AuthServicesImpl();
//   bool isLoggedIn = false;
//   bool isAdmin = false;
//
//   Future<void> handleAuthState() async {
//     // Check if the user is logged in using the MySQL-backed AuthServices implementation
//     isLoggedIn = await authServices.isLoggedIn();
//
//     if (isLoggedIn) {
//       // If logged in, check if the user is an admin
//       isAdmin = await authServices.isAdmin();
//     } else {
//       // If not logged in, reset the admin flag
//       isAdmin = false;
//     }
//     notifyListeners();
//   }
//
//   Future<void> showLogoutConfirmationDialog(BuildContext context) async {
//     final bool? shouldLogout = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Are you sure you want to logout?'),
//           actions: <Widget>[
//             Column(
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: const Text('Logout'),
//                 ),
//                 const Divider(),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//
//     if (shouldLogout == true) {
//       // Use the MySQL-backed AuthServices to log out
//       await authServices.logout();
//       isLoggedIn = false;
//       notifyListeners();
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.login,
//         (route) => false,
//       );
//     }
//   }
// }
class ProfileProvider with ChangeNotifier {
  final AuthServices authServices = AuthServicesImpl();
  bool isLoggedIn = false;
  bool isAdmin = false;

  Future<void> handleAuthState() async {
    // Check if the user is logged in using the MySQL-backed AuthServices implementation
    isLoggedIn = await authServices.isLoggedIn();

    if (isLoggedIn) {
      // If logged in, check if the user is an admin
      isAdmin = await authServices.isAdmin();
    } else {
      // If not logged in, reset the admin flag
      isAdmin = false;
    }
    notifyListeners(); // Notify listeners to update UI after login/logout
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
      // Use the MySQL-backed AuthServices to log out
      await authServices.logout();
      isLoggedIn = false;
      isAdmin = false;
      notifyListeners(); // Notify listeners to update the UI
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }
}
