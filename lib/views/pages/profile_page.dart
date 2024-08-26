import 'package:e_commerce_app_flutter/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final AuthServicesImpl authServices = AuthServicesImpl();
//   bool isLoggedIn = true;
//   bool isAdmin = false;
//
//   // Future<void> handleAuthState() async {
//   //   final User? user = firebaseAuth.currentUser;
//   //   if (user != null) {
//   //     final bool adminStatus = await authServices.isAdmin();
//   //     setState(() {
//   //       isLoggedIn = true;
//   //       isAdmin = adminStatus;
//   //     });
//   //   } else {
//   //     setState(() {
//   //       isLoggedIn = false;
//   //       isAdmin = false;
//   //     });
//   //   }
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//
//     handleAuthState();
//   }
//
//   // Future<void> _showLogoutConfirmationDialog() async {
//   //   final bool? shouldLogout = await showDialog<bool>(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text('Are you sure you want to logout?'),
//   //         actions: <Widget>[
//   //           Column(
//   //             children: [
//   //               TextButton(
//   //                 onPressed: () {
//   //                   Navigator.of(context).pop(true);
//   //                 },
//   //                 child: const Text('Logout'),
//   //               ),
//   //               const Divider(),
//   //               TextButton(
//   //                 onPressed: () {
//   //                   Navigator.of(context).pop(false);
//   //                 },
//   //                 child: const Text('Cancel'),
//   //               ),
//   //             ],
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   //
//   //   if (shouldLogout == true) {
//   //     await firebaseAuth.signOut();
//   //     setState(() {
//   //       isLoggedIn = false;
//   //     });
//   //     Navigator.pushNamedAndRemoveUntil(
//   //       context,
//   //       AppRoutes.login,
//   //       (route) => false,
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final User? user = firebaseAuth.currentUser;
//
//     return FutureBuilder<bool>(
//       future: authServices.isAdmin(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final bool isAdmin = snapshot.data ?? false;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: user != null && user.photoURL != null
//                       ? NetworkImage(user.photoURL!)
//                       : null,
//                   child: user?.photoURL == null
//                       ? const Icon(Icons.person, size: 50)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (user != null)
//                 Center(
//                   child: FutureBuilder<String?>(
//                     future: authServices.getUsername(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Text('Loading...');
//                       } else if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       } else if (!snapshot.hasData || snapshot.data == null) {
//                         return const Text('Hi, User');
//                       } else {
//                         return Text(
//                           ' ${snapshot.data}'.toUpperCase(),
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge!
//                               .copyWith(fontWeight: FontWeight.w600),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               const SizedBox(height: 10),
//               if (user != null)
//                 Center(
//                   child: Text(
//                     user.email ?? 'No Email',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 ),
//               const SizedBox(height: 30),
//               if (!isAdmin) ...[
//                 ListTile(
//                   leading: const Icon(Icons.shopping_bag),
//                   title: const Text('My Orders'),
//                   onTap: () {
//                     Navigator.of(context, rootNavigator: true)
//                         .pushNamed(AppRoutes.myOrders);
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.home),
//                   title: const Text('Address Book'),
//                   onTap: () {
//                     Navigator.of(context, rootNavigator: true)
//                         .pushNamed(AppRoutes.addressBook);
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.payment),
//                   title: const Text('Payment Cards'),
//                   onTap: () {
//                     Navigator.of(context, rootNavigator: true)
//                         .pushNamed(AppRoutes.paymentCard);
//                   },
//                 ),
//                 const Divider(),
//               ],
//               ListTile(
//                 leading: isLoggedIn
//                     ? const Icon(Icons.logout)
//                     : const Icon(Icons.login),
//                 title: Text(isLoggedIn ? 'Logout' : 'Login'),
//                 onTap: () async {
//                   if (isLoggedIn) {
//                     await _showLogoutConfirmationDialog();
//                   } else if (!isLoggedIn) {
//                     Navigator.of(context, rootNavigator: true)
//                         .pushNamed(AppRoutes.login);
//                   }
//                 },
//               ),
//               const SizedBox(height: 100),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Schedule the call to handleAuthState to run after the build process is complete
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

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the provider
//     final profileProvider =
//         Provider.of<ProfileProvider>(context, listen: false);
//     profileProvider.handleAuthState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileProvider>(
//       builder: (context, profileProvider, child) {
//         final User? user = FirebaseAuth.instance.currentUser;
//
//         return FutureBuilder<bool>(
//           future: profileProvider.authServices.isAdmin(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             //   final bool isAdmin = snapshot.data ?? false;
//
//             return SingleChildScrollView(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: user != null && user.photoURL != null
//                           ? NetworkImage(user.photoURL!)
//                           : null,
//                       child: user?.photoURL == null
//                           ? const Icon(Icons.person, size: 50)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (user != null)
//                     Center(
//                       child: FutureBuilder<String?>(
//                         future: profileProvider.authServices.getUsername(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Text('Loading...');
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (!snapshot.hasData ||
//                               snapshot.data == null) {
//                             return const Text('Hi, User');
//                           } else {
//                             return Text(
//                               ' ${snapshot.data}'.toUpperCase(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleLarge!
//                                   .copyWith(fontWeight: FontWeight.w600),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   const SizedBox(height: 10),
//                   if (user != null)
//                     Center(
//                       child: Text(
//                         user.email ?? 'No Email',
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   if (!profileProvider.isAdmin) ...[
//                     ListTile(
//                       leading: const Icon(Icons.shopping_bag),
//                       title: const Text('My Orders'),
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true)
//                             .pushNamed(AppRoutes.myOrders);
//                       },
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(Icons.home),
//                       title: const Text('Address Book'),
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true)
//                             .pushNamed(AppRoutes.addressBook);
//                       },
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(Icons.payment),
//                       title: const Text('Payment Cards'),
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true)
//                             .pushNamed(AppRoutes.paymentCard);
//                       },
//                     ),
//                     const Divider(),
//                   ],
//                   ListTile(
//                     leading: profileProvider.isLoggedIn
//                         ? const Icon(Icons.logout)
//                         : const Icon(Icons.login),
//                     title:
//                         Text(profileProvider.isLoggedIn ? 'Logout' : 'Login'),
//                     onTap: () async {
//                       if (profileProvider.isLoggedIn) {
//                         await profileProvider
//                             .showLogoutConfirmationDialog(context);
//                       } else {
//                         Navigator.of(context, rootNavigator: true)
//                             .pushNamed(AppRoutes.login);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
