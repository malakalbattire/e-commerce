import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/payment_method_model.dart';
import '../../../provider/payment_provider.dart';
import '../../../utils/app_colors.dart';
import 'package:provider/provider.dart';

class PaymentItemWidget extends StatelessWidget {
  final PaymentMethodModel? paymentMethod;
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
          child: Consumer<PaymentProvider>(builder: (context, provider, child) {
            return ListTile(
              onTap: additionOnTap != null
                  ? additionOnTap
                  : () {
                      provider.choosePaymentMethod(paymentMethod!.id);
                    },
              leading: paymentMethod == null
                  ? const Icon(Icons.add)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl: paymentMethod!.imgUrl,
                        height: 100,
                        width: 100,
                      ),
                    ),
              title: Text(
                paymentMethod != null
                    ? paymentMethod!.name
                    : 'Add Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: paymentMethod != null
                  ? Text(
                      paymentMethod!.cardNumber,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.gray),
                    )
                  : null,
              trailing: paymentMethod != null
                  ? Radio<String>(
                      value: paymentMethod!.id,
                      groupValue: provider.selectedPaymentMethodId,
                      onChanged: (value) =>
                          provider.choosePaymentMethod(value!),
                    )
                  : null,
            );
          }),
        ),
      ),
    );
  }
}
