import 'package:e_commerce_app_flutter/models/order_model/order_model.dart';
import 'package:flutter/material.dart';

class OrderAddressAndPaymentWidget extends StatelessWidget {
  const OrderAddressAndPaymentWidget({
    super.key,
    required this.order,
    required this.context,
  });

  final OrderModel order;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address : ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                ' ${order.firstName} ${order.lastName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                ' ${order.countryName} / ${order.cityName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                ' ${order.phoneNumber} ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Number: ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Card Number: ${order.cardNumber}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
