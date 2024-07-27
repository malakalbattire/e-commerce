import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return Center(
        child: TextButton(
      onPressed: () async {
        await _firebaseAuth.signOut();
      },
      child: Text('logout'),
    ));
  }
}
