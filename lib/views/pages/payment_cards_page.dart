import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/views/widgets/build_payment_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';

class PaymentCardsPage extends StatefulWidget {
  const PaymentCardsPage({super.key});

  @override
  State<PaymentCardsPage> createState() => _PaymentCardsPageState();
}

class _PaymentCardsPageState extends State<PaymentCardsPage> {
  late AuthServices _authServices;

  @override
  void initState() {
    super.initState();

    _authServices = AuthServicesImpl();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final paymentProvider =
          Provider.of<CardPaymentProvider>(context, listen: false);

      final user = await _authServices.getUser();

      if (user != null && paymentProvider.state == PaymentState.initial) {
        paymentProvider.loadPaymentData(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserData?>(
        future: _authServices.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const SigninSignoutWidget();
          }

          final currentUser = snapshot.data!;

          return Consumer<CardPaymentProvider>(
            builder: (context, paymentProvider, child) {
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Payment Cards'),
                    centerTitle: true,
                  ),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      await paymentProvider.loadPaymentData(currentUser.id);
                    },
                    child: paymentProvider.state == PaymentState.loading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : paymentProvider.state == PaymentState.error
                            ? const SigninSignoutWidget()
                            : paymentProvider.paymentItems.isEmpty
                                ? const Center(
                                    child: Text('No payment cards available.'),
                                  )
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                    child: Column(
                                      children: paymentProvider.paymentItems
                                          .map(
                                            (payment) => BuildPaymentCardWidget(
                                              context: context,
                                              payment: payment,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
