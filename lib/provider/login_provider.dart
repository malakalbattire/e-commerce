import 'package:e_commerce_app_flutter/provider/notification_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum LoginState { initial, loading, loaded, error }

class LoginProvider with ChangeNotifier {
  final AuthServices _authServices = AuthServicesImpl();
  LoginState _state = LoginState.initial;
  String _errorMessage = '';

  LoginState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> login(
      BuildContext context, String email, String password) async {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    _state = LoginState.loading;
    notifyListeners();

    try {
      final user = await _authServices.login(email, password);

      if (user != null) {
        await notificationProvider.clearAllNotifications();
        Fluttertoast.showToast(msg: 'Login Success!');

        if (email == 'admin@gmail.com') {
          Navigator.pushNamed(context, AppRoutes.home);
        } else {
          Navigator.pushNamed(context, AppRoutes.home);
        }
      } else {
        _errorMessage = 'Login failed. Please check your credentials.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _state = LoginState.initial;
      notifyListeners();
    }
  }

  Future<User?> register(String email, String password, String username) async {
    _state = LoginState.loading;
    notifyListeners();

    try {
      final result = await _authServices.register(email, password, username);
      if (result) {
        final user = await _authServices.getUser();
        _state = LoginState.loaded;
        notifyListeners();
        return user;
      } else {
        _state = LoginState.error;
        _errorMessage = 'Login failed: Invalid credentials.';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    _state = LoginState.loading;
    notifyListeners();

    try {
      await _authServices.logout();
      _state = LoginState.initial;
      notifyListeners();
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<User?> getUser() async {
    User? userData = await _authServices.getUser();
    if (userData != null) {
      notifyListeners();
      return userData;
    } else {
      return null;
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      bool isLoggedIn = await _authServices.isLoggedIn();
      return isLoggedIn;
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
