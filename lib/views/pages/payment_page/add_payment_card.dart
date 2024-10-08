import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/provider/card_payment_provider.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late AuthServices _authServices;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
    _authServices = AuthServicesImpl();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: _authServices.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SigninSignoutWidget();
        }

        final userId = snapshot.data!.id;

        return ChangeNotifierProvider(
          create: (_) => CardPaymentProvider(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Payment Card'),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your card number';
                            } else if (value.length < 16) {
                              return 'Card number must be 16 digits';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your card number',
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            } else if (!RegExp(r'^\d{2}/\d{2}$')
                                .hasMatch(value)) {
                              return 'Expiry date must be in MM/YY format';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            hintText: 'MM/YY',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your CVV';
                            } else if (value.length != 3) {
                              return 'CVV must be 3 digits';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'CVV',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final cardPaymentProvider =
                                    Provider.of<CardPaymentProvider>(context,
                                        listen: false);
                                await cardPaymentProvider.submitCard(
                                  cardNumber: _cardNumberController.text,
                                  cvvCode: _cvvController.text,
                                  expiryDate: _expiryDateController.text,
                                  userId: userId,
                                  context: context,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Add Card',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Colors.white,
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
          ),
        );
      },
    );
  }
}
