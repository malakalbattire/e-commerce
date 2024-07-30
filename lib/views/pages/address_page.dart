import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/address_model.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _lastNameController,
      _firstNameController,
      _phoneNumberController,
      _countryNameController,
      _cityNameController;
  late FocusNode _lastNameFocusNode,
      _firstNameFocusNode,
      _phoneNumberFocusNode,
      _countryNameFocusNode,
      _cityNameFocusNode;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _lastNameController = TextEditingController();
    _firstNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _countryNameController = TextEditingController();
    _cityNameController = TextEditingController();
    _lastNameFocusNode = FocusNode();
    _firstNameFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _countryNameFocusNode = FocusNode();
    _cityNameFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddressProvider>(context, listen: false);
      if (provider.addressItems.isEmpty) {
        provider.loadAddressData();
      }
    });
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _countryNameController.dispose();
    _cityNameController.dispose();
    super.dispose();
  }

  Future<void> _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        id: DateTime.timestamp().toIso8601String(),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        countryName: _countryNameController.text,
        cityName: _cityNameController.text,
      );

      await Provider.of<AddressProvider>(context, listen: false)
          .addAddress(address);

      final provider = Provider.of<AddressProvider>(context, listen: false);
      if (provider.state == AddressState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address submitted successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddressProvider(),
      child: Scaffold(
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
                    Text(
                      'Last Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _lastNameFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_firstNameFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your last name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'First Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _firstNameController,
                      focusNode: _firstNameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _firstNameFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_phoneNumberFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your first name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Phone Number',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneNumberController,
                      focusNode: _phoneNumberFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _phoneNumberFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(_countryNameFocusNode);
                      },
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Country Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _countryNameController,
                      focusNode: _countryNameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _countryNameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_cityNameFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your country name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your country name',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'City Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityNameController,
                      focusNode: _cityNameFocusNode,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your city name',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _submitAddress(),
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
  }
}
