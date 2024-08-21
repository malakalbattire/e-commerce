import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
  final firestore = FirestoreServices.instance;

  @override
  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final isAdmin = userDoc.data()?['role'] == 'admin';
    print('Is Admin: $isAdmin');
    return isAdmin;
  }

  @override
  Future<bool> login(String email, String password) async {
    UserCredential userData = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userData.user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password, String username) async {
    UserCredential userData = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    if (userData.user != null) {
      final currentUserData = UserData(
        id: userData.user!.uid,
        email: email,
        username: username,
      );
      await firestore.setData(
        path: ApiPath.user(currentUserData.id),
        data: currentUserData.toMap(),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Stream<String?> usernameStream() {
    return _firebaseAuth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        try {
          final doc = await firestore.getDocument(
            path: 'users/${user.uid}',
            builder: (data, documentId) => data['username'] as String?,
          );
          return doc;
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching username: $e');
          }
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
      try {
        final doc = await firestore.getDocument(
          path: 'users/${user.uid}',
          builder: (data, documentId) => data['username'] as String?,
        );
        return doc;
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching username: $e');
        }
      }
    }
    return null;
  }
}
