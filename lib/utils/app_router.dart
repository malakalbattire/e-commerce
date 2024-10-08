import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/provider/notification_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/provider/product_providers/product_details_provider.dart';
import 'package:e_commerce_app_flutter/provider/product_providers/product_provider.dart';
import 'package:e_commerce_app_flutter/views/pages/add_product_page.dart';
import 'package:e_commerce_app_flutter/views/pages/address_page/address_book_page.dart';
import 'package:e_commerce_app_flutter/views/pages/address_page/address_page.dart';
import 'package:e_commerce_app_flutter/views/pages/notifications_page.dart';
import 'package:e_commerce_app_flutter/views/pages/payment_cards_page.dart';
import 'package:e_commerce_app_flutter/views/pages/product_pages/product_list_page.dart';
import 'package:e_commerce_app_flutter/views/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../views/pages/payment_page/add_payment_card.dart';
import '../views/pages/custom_bottom_navbar.dart';
import '../views/pages/login_page.dart';
import '../views/pages/order_pages /my_orders_page.dart';
import '../views/pages/payment_page/checkout_page.dart';
import '../views/pages/product_pages/product_details_page.dart';
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
      case AppRoutes.addressBook:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => AddressProvider(),
              child: const AddressBookPage(),
            );
          },
          settings: settings,
        );
      case AppRoutes.paymentCard:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => CardPaymentProvider(),
              child: PaymentCardsPage(),
            );
          },
          settings: settings,
        );
      case AppRoutes.notification:
        return MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => NotificationProvider(),
              child: const NotificationPage(),
            );
          },
          settings: settings,
        );
      case AppRoutes.myOrders:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: Provider.of<OrderProvider>(_, listen: false),
            child: const MyOrdersPage(),
          ),
          settings: settings,
        );
      case AppRoutes.payment:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: Provider.of<CheckoutProvider>(_, listen: false),
            child: CheckoutPage(),
          ),
          settings: settings,
        );
      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
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
          builder: (_) => const CustomBottomNavbar(),
          settings: settings,
        );
      case AppRoutes.addProduct:
        return MaterialPageRoute(
          builder: (_) => const AddProductPage(),
          settings: settings,
        );
      case AppRoutes.productsList:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProductProvider(),
            child: ProductListPage(),
          ),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(),
          settings: settings,
        );
      case AppRoutes.address:
        return MaterialPageRoute(
          builder: (_) => const AddressPage(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
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
