import 'package:e_commerce_app_flutter/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.handleAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final User? user = FirebaseAuth.instance.currentUser;

        return FutureBuilder<bool>(
          future: profileProvider.authServices.isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        future: profileProvider.authServices.getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
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
                  if (!profileProvider.isAdmin) ...[
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
                      leading: const Icon(Icons.payment),
                      title: const Text('Payment Cards'),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(AppRoutes.paymentCard);
                      },
                    ),
                    const Divider(),
                  ],
                  ListTile(
                    leading: profileProvider.isLoggedIn
                        ? const Icon(Icons.logout)
                        : const Icon(Icons.login),
                    title:
                        Text(profileProvider.isLoggedIn ? 'Logout' : 'Login'),
                    onTap: () async {
                      if (profileProvider.isLoggedIn) {
                        await profileProvider
                            .showLogoutConfirmationDialog(context);
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(AppRoutes.login);
                      }
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
