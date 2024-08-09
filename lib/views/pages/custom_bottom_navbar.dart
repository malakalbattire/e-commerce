import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/pages/add_product_page.dart';
import 'package:e_commerce_app_flutter/views/pages/admin_home_page.dart';
import 'package:e_commerce_app_flutter/views/pages/admin_orders_page.dart';
import 'package:e_commerce_app_flutter/views/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/favorites_provider.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  final AuthServicesImpl authServices = AuthServicesImpl();
  Future<bool>? isAdminFuture;

  @override
  void initState() {
    super.initState();
    isAdminFuture = authServices.isAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: FutureBuilder<String?>(
          future: authServices.getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Hi, User');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${snapshot.data}',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Let\'s go shopping!',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.grey),
                  ),
                ],
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: isAdminFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            return PersistentTabView(
              tabs: [
                PersistentTabConfig(
                  screen: AdminHomePage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.home),
                    title: "Admin Home",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: AddProductPage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.home),
                    title: "Admin Home",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: AdminOrdersPage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.list),
                    title: "Orders",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: ProfilePage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.person),
                    title: "profile",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) => Style6BottomNavBar(
                navBarConfig: navBarConfig,
              ),
            );
          } else {
            return PersistentTabView(
              tabs: [
                PersistentTabConfig(
                  screen: HomePage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.home),
                    title: "Home",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: ChangeNotifierProvider(
                    create: (_) => CartProvider(),
                    child: CartPage(),
                  ),
                  item: ItemConfig(
                    icon: const Icon(Icons.shopping_cart),
                    title: "Cart",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: ChangeNotifierProvider(
                    create: (_) => FavoritesProvider(),
                    child: FavoritesPage(),
                  ),
                  item: ItemConfig(
                    icon: const Icon(Icons.favorite_border),
                    title: "Favorite",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
                PersistentTabConfig(
                  screen: ProfilePage(),
                  item: ItemConfig(
                    icon: const Icon(Icons.person),
                    title: "Profile",
                    activeForegroundColor: Theme.of(context).primaryColor,
                    inactiveForegroundColor: Colors.grey,
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) => Style6BottomNavBar(
                navBarConfig: navBarConfig,
              ),
            );
          }
        },
      ),
    );
  }
}
