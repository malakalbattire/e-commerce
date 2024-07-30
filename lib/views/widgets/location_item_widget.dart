import 'package:e_commerce_app_flutter/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationItemWidget extends StatefulWidget {
  final int index;
  const LocationItemWidget({super.key, required this.index});

  @override
  State<LocationItemWidget> createState() => _LocationItemWidgetState();
}

class _LocationItemWidgetState extends State<LocationItemWidget> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<PaymentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(),
    );
  }
}
