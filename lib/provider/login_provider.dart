import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/notification_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum LoginState { initial, loading, loaded, error }

class LoginProvider with ChangeNotifier {
  final AuthServices _authServices =
      AuthServicesImpl(); // Using the MySQL Auth implementation
  LoginState _state = LoginState.initial;
  String _errorMessage = '';

  LoginState get state => _state;
  String get errorMessage => _errorMessage;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  LoginProvider() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    _state = LoginState.loading;
    notifyListeners();

    try {
      // Use AuthServicesImpl's login method
      final isLoggedIn = await _authServices.login(email, password);

      if (isLoggedIn) {
        // Fetch user data after login
        final user = await _authServices.getUser();
        if (user != null) {
          // Assuming you store role in the user object fetched from MySQL
          final userRole = user.userRole;

          await notificationProvider.clearAllNotifications();
          Fluttertoast.showToast(msg: 'Login Success!');

          // Redirect user based on their role
          if (userRole == 'admin') {
            Navigator.pushNamed(context,
                '/adminHome'); // Assuming /adminHome is the route for admin
          } else {
            Navigator.pushNamed(context,
                '/home'); // Assuming /home is the default route for users
          }
        } else {
          _errorMessage = 'Login failed. User data could not be retrieved.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage)),
          );
        }
      } else {
        _errorMessage = 'Login failed. Please check your credentials.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage)),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      _state = LoginState.initial;
      notifyListeners();
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

  Future<UserData?> getUser() async {
    UserData? userData = await _authServices.getUser();
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

  Future<bool> isAdmin() async {
    try {
      bool isAdmin = await _authServices.isAdmin();
      return isAdmin;
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Stream<String?> usernameStream() {
    return _authServices.usernameStream();
  }
}
