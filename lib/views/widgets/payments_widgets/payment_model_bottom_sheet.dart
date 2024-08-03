import 'package:e_commerce_app_flutter/views/widgets/payments_widgets/payment_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';

class PaymentModelBottomSheet extends StatelessWidget {
  const PaymentModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              //itemCount: savedCards.length,
              itemBuilder: (context, index) {
                //  return PaymentItemWidget(paymentMethod: savedCards[index]);
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
  }
}
