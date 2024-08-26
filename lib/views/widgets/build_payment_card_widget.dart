import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildPaymentCardWidget extends StatelessWidget {
  const BuildPaymentCardWidget({
    super.key,
    required this.context,
    required this.payment,
  });

  final BuildContext context;
  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
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
