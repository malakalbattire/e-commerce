import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import 'package:provider/provider.dart';

class PaymentItemWidget extends StatelessWidget {
  final PaymentModel? paymentMethod;
  final VoidCallback? additionOnTap;
  const PaymentItemWidget({
    super.key,
    this.paymentMethod,
    this.additionOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Consumer<CardPaymentProvider>(
              builder: (context, provider, child) {
            return ListTile(
              onTap: additionOnTap ??
                  () {
                    provider.choosePayment(paymentMethod!.id);
                  },
              leading: paymentMethod == null
                  ? const Icon(Icons.add)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
                        height: 80,
                        width: 80,
                      ),
                    ),
              title: Text(
                paymentMethod != null
                    ? paymentMethod!.cardNumber
                    : 'Add Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: paymentMethod != null
                  ? Radio<String>(
                      value: paymentMethod!.id,
                      groupValue: provider.selectedPaymentId,
                      onChanged: (value) => provider.choosePayment(value!),
                    )
                  : null,
            );
          }),
        ),
      ),
    );
  }
}
