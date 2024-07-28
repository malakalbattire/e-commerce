import 'package:e_commerce_app_flutter/models/user_data.dart';
import 'package:e_commerce_app_flutter/services/firestore_services.dart';
import 'package:e_commerce_app_flutter/utils/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServices {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String username);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User?> getUser();
  Future<String?> getUsername();
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final firestore = FirestoreServices.instance;

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
    User? user = await _firebaseAuth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<User?> getUser() async {
    return await _firebaseAuth.currentUser;
  }

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
        print('Error fetching username: $e');
      }
    }
    return null;
  }
}
