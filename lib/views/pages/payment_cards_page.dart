import 'package:e_commerce_app_flutter/views/widgets/build_payment_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';

class PaymentCardsPage extends StatefulWidget {
  const PaymentCardsPage({super.key});

  @override
  State<PaymentCardsPage> createState() => _PaymentCardsPageState();
}

class _PaymentCardsPageState extends State<PaymentCardsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;

      final paymentProvider =
          Provider.of<CardPaymentProvider>(context, listen: false);
      if (paymentProvider.state == PaymentState.initial) {
        paymentProvider.loadPaymentData(currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Consumer<CardPaymentProvider>(
        builder: (context, paymentProvider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Payment Cards'),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await paymentProvider.loadPaymentData(currentUser!.uid);
                },
                child: paymentProvider.state == PaymentState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : paymentProvider.state == PaymentState.error
                        ? const SigninSignoutWidget()
                        : paymentProvider.paymentItems.isEmpty
                            ? const Center(
                                child: Text('No payment cards available.'))
                            : SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: Column(
                                  children: [
                                    ...paymentProvider.paymentItems.map(
                                      (payment) => BuildPaymentCardWidget(
                                          context: context, payment: payment),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ),
          );
        },
      ),
    );
  }
}
