import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthServices {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String username);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User?> getUser();
  Future<String?> getUsername();
  Future<bool> isAdmin();
  Stream<String?> usernameStream();
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final String backendUrl = 'http://192.168.88.2:3000';

  @override
  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final response =
          await http.get(Uri.parse('$backendUrl/users/${user.uid}'));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        if (userData is Map<String, dynamic>) {
          final userRole = userData['userRole'] as String?;
          final isAdmin = userRole == 'admin';
          print('Is Admin: $isAdmin');
          return isAdmin;
        } else {
          print('Unexpected user data format: $userData');
          return false;
        }
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
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
      UserCredential userData = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userData.user != null;
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
      UserCredential userData = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userData.user != null) {
        final currentUserData = {
          'id': userData.user!.uid,
          'email': email,
          'username': username,
          'userRole': 'customer',
        };

        final response = await http.post(
          Uri.parse('$backendUrl/users'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(currentUserData),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          print('register sucses');
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Registration Error========: $e');
      }
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  @override
  Stream<String?> usernameStream() {
    return _firebaseAuth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        try {
          final response =
              await http.get(Uri.parse('$backendUrl/users/${user.uid}'));

          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');

          if (response.statusCode == 200) {
            final userData = json.decode(response.body);
            print('Decoded user data: $userData');

            if (userData is Map<String, dynamic>) {
              return userData['username'] as String?;
            } else {
              print('Unexpected JSON structure: $userData');
              return null;
            }
          } else {
            print('Failed to load username: ${response.statusCode}');
            return null;
          }
        } catch (e) {
          print('Error fetching username: $e');
          return null;
        }
      } else {
        return null;
      }
    });
  }

  @override
  Future<String?> getUsername() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final response =
          await http.get(Uri.parse('$backendUrl/users/${user.uid}'));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return userData['username'] as String?;
      }
    }
    return null;
  }
}
