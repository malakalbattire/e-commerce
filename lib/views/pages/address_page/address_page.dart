import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Page'),
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
                  _buildTextField(
                    context: context,
                    controller: addressProvider.lastNameController,
                    focusNode: addressProvider.lastNameFocusNode,
                    nextFocusNode: addressProvider.firstNameFocusNode,
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    context: context,
                    controller: addressProvider.firstNameController,
                    focusNode: addressProvider.firstNameFocusNode,
                    nextFocusNode: addressProvider.phoneNumberFocusNode,
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    context: context,
                    controller: addressProvider.phoneNumberController,
                    focusNode: addressProvider.phoneNumberFocusNode,
                    nextFocusNode: addressProvider.countryNameFocusNode,
                    label: 'Phone Number',
                    hintText: 'Enter your phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    context: context,
                    controller: addressProvider.countryNameController,
                    focusNode: addressProvider.countryNameFocusNode,
                    nextFocusNode: addressProvider.cityNameFocusNode,
                    label: 'Country Name',
                    hintText: 'Enter your country name',
                    icon: Icons.location_city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your country name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    context: context,
                    controller: addressProvider.cityNameController,
                    focusNode: addressProvider.cityNameFocusNode,
                    label: 'City Name',
                    hintText: 'Enter your city name',
                    icon: Icons.location_city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city name';
                      }
                      return null;
                    },
                    nextFocusNode: null,
                  ),
                  const SizedBox(height: 24),
                  addressProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await addressProvider.submitAddress();
                                if (addressProvider.state ==
                                    AddressState.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(addressProvider.errorMessage)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Address submitted successfully!')),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Submit Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
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

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          keyboardType: keyboardType,
          onEditingComplete: () {
            if (nextFocusNode != null) {
              focusNode.unfocus();
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus();
            }
          },
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
