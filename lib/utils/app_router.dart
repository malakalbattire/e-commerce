import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../views/pages/add_payment_card.dart';
import '../views/pages/custom_bottom_navbar.dart';
import '../views/pages/login_page.dart';
import '../views/pages/my_orders_page.dart';
import '../views/pages/payment_page.dart';
import '../views/pages/product_details_page.dart';
import '../views/pages/registration_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.productDetails:
        return MaterialPageRoute(
          builder: (_) => const ProductDetailsPage(),
        );
      case AppRoutes.myOrders:
        return MaterialPageRoute(
          builder: (_) => MyOrdersPage(),
          settings: settings,
        );
      case AppRoutes.payment:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: Provider.of<CartProvider>(_, listen: false),
            child: PaymentPage(),
          ),
          settings: settings,
        );

      case AppRoutes.addPaymentCard:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: Provider.of<CartProvider>(_, listen: false),
            child: AddPaymentCard(),
          ),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => CustomBottomNavbar(),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error Page'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
