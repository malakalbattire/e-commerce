import 'package:e_commerce_app_flutter/provider/add_product_provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/provider/admin_orders_provider.dart';
import 'package:e_commerce_app_flutter/provider/admin_product_provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/provider/favorites_provider.dart';
import 'package:e_commerce_app_flutter/provider/order_provider.dart';
import 'package:e_commerce_app_flutter/provider/product_details_provider.dart';
import 'package:e_commerce_app_flutter/services/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'provider/cart_provider.dart';
import 'provider/category_provider.dart';
import 'provider/home_provider.dart';
import 'provider/login_provider.dart';
import 'provider/notification_provider.dart';
import 'provider/payment_provider.dart';
import 'provider/product_item_provider.dart';
import 'provider/product_provider.dart';
import 'provider/register_provider.dart';
import 'utils/app_colors.dart';
import 'utils/app_router.dart';
import 'utils/app_routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseNotifications firebaseNotifications = FirebaseNotifications();
  await firebaseNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => CardPaymentProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
        ChangeNotifierProvider(create: (_) => AdminOrdersProvider()),
        ChangeNotifierProvider(create: (_) => ProductItemProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => AddProductProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter E-commerce',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppColors.gray2,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.gray1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.gray1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.gray1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.gray1),
            ),
          ),
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
