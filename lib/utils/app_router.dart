import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';
import 'package:e_commerce_app_flutter/views/pages/address_page.dart';
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
        final productId = settings.arguments as String?;
        if (productId == null) {
          return _errorRoute('Product ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) {
              final provider = ProductDetailsProvider();
              provider.getProductDetails(productId);
              return provider;
            },
            child: ProductDetailsPage(productId: productId),
          ),
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
      case AppRoutes.address:
        return MaterialPageRoute(
          builder: (_) => AddressPage(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      default:
        return _errorRoute('Page not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
