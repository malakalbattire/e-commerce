import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app_flutter/models/payment_model/payment_model.dart';
import 'package:flutter/material.dart';

class PaymentCardWidget extends StatelessWidget {
  final PaymentModel payment;

  const PaymentCardWidget({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: CachedNetworkImage(
            imageUrl:
                'https://i.pinimg.com/564x/56/65/ac/5665acfeb0668fe3ffdeb3168d3b38a4.jpg',
            height: 80,
            width: 80,
          ),
        ),
        const SizedBox(width: 8),
        Text(payment.cardNumber),
      ],
    );
  }
}
