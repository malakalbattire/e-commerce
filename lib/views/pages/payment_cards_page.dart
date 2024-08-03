import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
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
      final paymentProvider =
          Provider.of<CardPaymentProvider>(context, listen: false);
      if (paymentProvider.state == PaymentState.initial) {
        paymentProvider.loadPaymentData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                await paymentProvider.loadPaymentData();
              },
              child: paymentProvider.state == PaymentState.loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : paymentProvider.state == PaymentState.error
                      ? Center(
                          child: Text('Error: ${paymentProvider.errorMessage}'))
                      : paymentProvider.paymentItems.isEmpty
                          ? const Center(
                              child: Text('No payment cards available.'))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Column(
                                children: [
                                  ...paymentProvider.paymentItems.map(
                                    (payment) => _buildPaymentCard(payment),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   payment.cardHolderName,
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16.0,
            //   ),
            // ),
            const SizedBox(height: 8.0),
            Text(
              'Card Number: ${payment.cardNumber}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Expiry Date: ${payment.expiryDate}',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<CardPaymentProvider>(context, listen: false)
                        .removePayment(payment.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
