import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';

enum RegisterState { initial, loading, loaded, error }

class RegisterProvider with ChangeNotifier {
  final AuthServices _authServices = AuthServicesImpl();
  RegisterState _state = RegisterState.initial;
  String _errorMessage = '';

  RegisterState get state => _state;
  String get errorMessage => _errorMessage;

  Future<User?> register(
    String email,
    String password,
    String username,
  ) async {
    _state = RegisterState.loading;
    notifyListeners();

    try {
      final result = await _authServices.register(email, password, username);
      if (result) {
        final user = await _authServices.getUser();
        _state = RegisterState.loaded;
        notifyListeners();
        return user;
      } else {
        _state = RegisterState.error;
        _errorMessage = 'Registration failed: Invalid credentials.';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _state = RegisterState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
