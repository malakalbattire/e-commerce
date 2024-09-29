import 'package:e_commerce_app_flutter/provider/notification_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum RegisterState { initial, loading, success, error }

class RegisterProvider with ChangeNotifier {
  final AuthServices _authServices = AuthServicesImpl();
  RegisterState _state = RegisterState.initial;
  String _errorMessage = '';

  RegisterState get state => _state;
  String get errorMessage => _errorMessage;
  late final TextEditingController _usernameController,
      _emailController,
      _passwordController;
  late FocusNode _usernameFocusNode, _emailFocusNode, _passwordFocusNode;

  RegisterProvider() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required NotificationProvider notificationProvider,
    required BuildContext context,
  }) async {
    _state = RegisterState.loading;
    notifyListeners();
    try {
      print('Starting registration');
      final result = await _authServices.register(email, password, username);
      print('Registration result: $result');
      if (result) {
        final user = await _authServices.getUser();
        print('User retrieved: $user');
        if (user != null) {
          await notificationProvider.clearAllNotifications();

          print('Registration success, showing toast');
          Fluttertoast.showToast(
            msg: 'Register Success!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          if (context.mounted) {
            print('Navigating to home');
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else {
            print('Context not mounted, cannot navigate');
          }

          _state = RegisterState.success;
        } else {
          print('Registration failed: User is null.');
          _errorMessage = 'Registration failed: User is null.';
          _state = RegisterState.error;
        }
      } else {
        print('Registration failed: Invalid credentials.');
        _errorMessage = 'Registration failed: Invalid credentials.';
        _state = RegisterState.error;
      }
    } catch (e) {
      print('Error during registration: $e');
      _errorMessage = e.toString();
      _state = RegisterState.error;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
