import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/utils/backend_url.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class AuthServices {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String username);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserData?> getUser();
  Future<String?> getUsername();
  Future<bool> isAdmin();
  Stream<String?> usernameStream();
}

class AuthServicesImpl implements AuthServices {
  String? _currentUserId;
  String? _currentUsername;

  @override
  Future<bool> isAdmin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('currentUserId');

      if (_currentUserId == null) {
        print('No user ID found in SharedPreferences');
        return false;
      }

      final response = await http.get(
        Uri.parse('${BackendUrl.url}/users/$_currentUserId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final userRole = userData['userRole'] as String?;
        final isAdmin = userRole == 'admin';
        print('Is Admin: $isAdmin');
        return isAdmin;
      } else {
        print('Error fetching user data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return false;
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendUrl.url}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        print('Login successful: $userData');
        _currentUserId = userData['id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUserId', _currentUserId!);

        _currentUsername = userData['username'];
        print(_currentUserId);
        print(_currentUsername);
        return true;
      } else {
        if (kDebugMode) {
          print('Login failed: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login Error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password, String username) async {
    try {
      var uuid = Uuid();
      String userId = uuid.v4();
      final currentUserData = {
        'id': userId,
        'email': email,
        'username': username,
        'userRole': 'customer',
        'password': password,
      };

      final response = await http.post(
        Uri.parse('${BackendUrl.url}/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(currentUserData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Registration successful');
        return true;
      } else {
        if (kDebugMode) {
          print('Registration failed: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Registration Error: $e');
      }
    }
    return false;
  }

  @override
  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${BackendUrl.url}/logout'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Logged out successfully');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('currentUserId');
      } else {
        print('Error logging out: ${response.body}');
      }
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('currentUserId');

      if (_currentUserId != null) {
        print('User is logged in with ID: $_currentUserId');
        return true;
      } else {
        print('No user is logged in.');
        return false;
      }
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  @override
  Future<UserData?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('currentUserId');

    if (_currentUserId != null) {
      try {
        final response = await http.get(
          Uri.parse('${BackendUrl.url}/users/$_currentUserId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          return UserData(
            id: userData['id'],
            email: userData['email'],
            username: userData['username'],
            userRole: userData['userRole'],
          );
        } else {
          print('Error fetching user: ${response.body}');
          return null;
        }
      } catch (e) {
        print('Error getting user: $e');
        return null;
      }
    } else {
      print('No user ID found in SharedPreferences.');
      return null;
    }
  }

  @override
  Future<String?> getUsername() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('currentUserId');

      if (_currentUserId == null) {
        print('No user ID found in SharedPreferences');
        return null;
      }

      print('Fetching username for userId: $_currentUserId');

      final response = await http.get(
        Uri.parse('${BackendUrl.url}/users/$_currentUserId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return userData['username'] as String?;
      } else {
        print('Error fetching username: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  @override
  Stream<String?> usernameStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 10));
      yield await getUsername();
    }
  }
}
