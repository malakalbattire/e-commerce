import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final User? user = _firebaseAuth.currentUser;
    final AuthServicesImpl authServices = AuthServicesImpl();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user != null && user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          if (user != null)
            Center(
              child: FutureBuilder<String?>(
                future: authServices.getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('Hi, User');
                  } else {
                    return Text(
                      ' ${snapshot.data}'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    );
                  }
                },
              ),
            ),
          const SizedBox(height: 10),
          if (user != null)
            Center(
              child: Text(
                user.email ?? 'No Email',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(AppRoutes.myOrders);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Address Book'),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(AppRoutes.addressBook);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Account Settings'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await _firebaseAuth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
