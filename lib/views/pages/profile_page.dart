import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserData?> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.handleAuthState();
    });
    _currentUserFuture = _loadCurrentUser();
  }

  Future<UserData?> _loadCurrentUser() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return await profileProvider.authServices.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
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
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<UserData?>(
                    future: _currentUserFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('Hi, User'));
                      } else {
                        final user = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              user.username.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                user.email ?? 'No Email',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  if (!profileProvider.isAdmin &&
                      profileProvider.isLoggedIn) ...[
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
