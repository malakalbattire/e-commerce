import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/payment_provider.dart'; // Assuming you have a PaymentProvider

class AddPaymentCard extends StatefulWidget {
  const AddPaymentCard({super.key});

  @override
  State<AddPaymentCard> createState() => _AddPaymentCardState();
}

class _AddPaymentCardState extends State<AddPaymentCard> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _cardNumberController,
      _expiryDateController,
      _cvvController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Future<void> _addCard() async {
  //   final paymentProvider =
  //       Provider.of<PaymentProvider>(context, listen: false);
  //
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isSubmitting = true;
  //     });
  //
  //     // final success = await paymentProvider.addPaymentCard(
  //     //   _cardNumberController.text,
  //     //   _expiryDateController.text,
  //     //   _cvvController.text,
  //     // );
  //
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //
  //     if (success) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Card Added Successfully!'),
  //         ),
  //       );
  //       Navigator.pop(context); // Close the page on success
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(paymentProvider.errorMessage),
  //         ),
  //       );
  //     }
  //   }
  // }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with Card'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),
                  Text(
                    'Add Payment Card',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Please enter your card details.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.gray),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Card Number',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      } else if (value.length < 16) {
                        return 'Card number must be 16 digits';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter your card number',
                      prefixIcon: Icon(Icons.credit_card),
                      prefixIconColor: AppColors.gray,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _expiryDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter expiry date';
                                } else if (!RegExp(r'^\d{2}/\d{2}$')
                                    .hasMatch(value)) {
                                  return 'Expiry date must be in MM/YY format';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                hintText: 'MM/YY',
                                prefixIcon: Icon(Icons.calendar_today),
                                prefixIconColor: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CVV',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _cvvController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your CVV';
                                } else if (value.length != 3) {
                                  return 'CVV must be 3 digits';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'CVV',
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {}, // _isSubmitting ? null : _addCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: AppColors.white,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'Add Card',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
