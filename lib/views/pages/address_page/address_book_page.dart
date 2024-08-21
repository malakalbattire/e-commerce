import 'package:e_commerce_app_flutter/views/widgets/address_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (addressProvider.state == AddressState.initial) {
        addressProvider.loadAddressData(currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Address Book'),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await addressProvider.loadAddressData(currentUser!.uid);
                },
                child: addressProvider.state == AddressState.loading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : addressProvider.state == AddressState.error
                        ? const SigninSignoutWidget()
                        : addressProvider.addressItems.isEmpty
                            ? const Center(
                                child: Text('No addresses available.'))
                            : SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: Column(
                                  children: [
                                    ...addressProvider.addressItems.map(
                                      (address) => AddressCardWidget(
                                          context: context, address: address),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ),
          );
        },
      ),
    );
  }
}
