import 'package:flutter/material.dart';

class CartTotalAndSubtotalItemWidget extends StatelessWidget {
  const CartTotalAndSubtotalItemWidget({
    super.key,
    required this.context,
    required this.title,
    required this.amount,
  });

  final BuildContext context;
  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '\$ ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
