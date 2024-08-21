import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentModelBottomSheet extends StatelessWidget {
  const PaymentModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Consumer<CardPaymentProvider>(
      builder: (context, paymentProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (paymentProvider.state == PaymentState.initial) {
            paymentProvider.loadPaymentData(currentUser!.uid);
          }
        });

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: paymentProvider.state == PaymentState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : paymentProvider.state == PaymentState.error
                        ? Center(
                            child:
                                Text('Error: ${paymentProvider.errorMessage}'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: paymentProvider.paymentItems.length,
                            itemBuilder: (context, index) {
                              final payment =
                                  paymentProvider.paymentItems[index];
                              return GestureDetector(
                                onTap: () {
                                  paymentProvider.choosePayment(payment.id);
                                  Navigator.of(context).pop();
                                },
                                child:
                                    PaymentItemWidget(paymentMethod: payment),
                              );
                            },
                          ),
              ),
              PaymentItemWidget(
                additionOnTap: () {
                  Navigator.pushNamed(context, AppRoutes.addPaymentCard);
                },
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}
