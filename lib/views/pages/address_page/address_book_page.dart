import 'package:e_commerce_app_flutter/models/user_data/user_data.dart';
import 'package:e_commerce_app_flutter/services/auth_services.dart';
import 'package:e_commerce_app_flutter/views/widgets/address_card_widget.dart';
import 'package:e_commerce_app_flutter/views/widgets/signin_signout_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  late AuthServices _authServices;

  @override
  void initState() {
    super.initState();

    _authServices = AuthServicesImpl();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);

      final user = await _authServices.getUser();
      if (user != null) {
        if (addressProvider.state == AddressState.initial) {
          addressProvider.loadAddressData(user.id);
          if (kDebugMode) {
            print("userid in address book page: ${user.id}");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Address Book'),
                centerTitle: true,
              ),
              body: FutureBuilder<UserData?>(
                future: _authServices.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SigninSignoutWidget();
                  }

                  final currentUser = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      await addressProvider.loadAddressData(currentUser.id);
                    },
                    child: addressProvider.state == AddressState.loading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
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
                                              context: context,
                                              address: address),
                                        ),
                                      ],
                                    ),
                                  ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
