import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/provider/checkout_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/views/widgets/inline_headline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../payments_widgets/payment_model_bottom_sheet.dart';

class CheckoutPaymentWidget extends StatelessWidget {
  const CheckoutPaymentWidget({
    super.key,
    required this.checkoutProvider,
  });

  final CheckoutProvider checkoutProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<CardPaymentProvider>(
      builder: (context, paymentProvider, child) {
        return StreamBuilder<List<PaymentModel>>(
          stream: Stream.fromFuture(Future.value(paymentProvider.paymentItems)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                children: [
                  InlineHeadlineWidget(
                    title: 'Payment Method',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => const PaymentModelBottomSheet(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => const PaymentModelBottomSheet(),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Text('Add Payment Method')),
                    ),
                  ),
                ],
              );
            }

            final selectedPaymentId = paymentProvider.selectedPaymentMethodId;
            final selectedPayment = snapshot.data!.firstWhere(
              (payment) => payment.id == selectedPaymentId,
              orElse: () => PaymentModel(
                id: '',
                cardNumber: '',
                cvvCode: '',
                expiryDate: '',
                userId: '',
              ),
            );

            return Column(
              children: [
                InlineHeadlineWidget(
                  title: 'Payment Method',
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const PaymentModelBottomSheet(),
                  ),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const PaymentModelBottomSheet(),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: selectedPayment.id.isEmpty
                          ? const Center(child: Text('Add Payment Method'))
                          : Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(selectedPayment.cardNumber),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
