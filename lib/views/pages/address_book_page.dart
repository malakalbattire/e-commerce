// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:e_commerce_app_flutter/provider/address_provider.dart';
// import 'package:e_commerce_app_flutter/models/address_model/address_model.dart'; // Update with your actual import path
//
// class AddressBookPage extends StatelessWidget {
//   const AddressBookPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final addressProvider = Provider.of<AddressProvider>(context);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (addressProvider.state == AddressState.initial) {
//         addressProvider.loadAddressData();
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Address Book'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddAddressDialog(context),
//           ),
//         ],
//       ),
//       body: addressProvider.state == AddressState.loading
//           ? const Center(child: CircularProgressIndicator())
//           : addressProvider.state == AddressState.error
//               ? Center(child: Text('Error: ${addressProvider.errorMessage}'))
//               : addressProvider.addressItems.isEmpty
//                   ? const Center(child: Text('No addresses available.'))
//                   : ListView.builder(
//                       itemCount: addressProvider.addressItems.length,
//                       itemBuilder: (context, index) {
//                         final address = addressProvider.addressItems[index];
//                         return ListTile(
//                           title:
//                               Text('${address.firstName} ${address.lastName}'),
//                           subtitle: Text(
//                               ' ${address.cityName}, ${address.countryName}'),
//                           trailing: PopupMenuButton<String>(
//                             onSelected: (value) {
//                               if (value == 'edit') {
//                                 _showEditAddressDialog(context, address);
//                               } else if (value == 'delete') {
//                                 addressProvider.removeAddress(address.id);
//                               }
//                             },
//                             itemBuilder: (context) => [
//                               const PopupMenuItem<String>(
//                                 value: 'edit',
//                                 child: Text('Edit'),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'delete',
//                                 child: Text('Delete'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }
//
//   void _showAddAddressDialog(BuildContext context) {
//     final addressProvider =
//         Provider.of<AddressProvider>(context, listen: false);
//     final _firstNameController = TextEditingController();
//     final _lastNameController = TextEditingController();
//     final _countryNameController = TextEditingController();
//     final _cityNameController = TextEditingController();
//     final _phoneNumberController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add Address'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//               ),
//               TextField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//               ),
//               TextField(
//                 controller: _countryNameController,
//                 decoration: const InputDecoration(labelText: 'Country'),
//               ),
//               TextField(
//                 controller: _cityNameController,
//                 decoration: const InputDecoration(labelText: 'City'),
//               ),
//               TextField(
//                 controller: _phoneNumberController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final addressModel = AddressModel(
//                   id: DateTime.now().toString(), // Generate unique ID
//                   firstName: _firstNameController.text,
//                   lastName: _lastNameController.text,
//                   countryName: _countryNameController.text,
//                   cityName: _cityNameController.text,
//                   phoneNumber: _phoneNumberController.text,
//                 );
//                 await addressProvider.addAddress(addressModel);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showEditAddressDialog(BuildContext context, AddressModel address) {
//     final addressProvider =
//         Provider.of<AddressProvider>(context, listen: false);
//     final _firstNameController = TextEditingController(text: address.firstName);
//     final _lastNameController = TextEditingController(text: address.lastName);
//     final _countryNameController =
//         TextEditingController(text: address.countryName);
//     final _cityNameController = TextEditingController(text: address.cityName);
//     final _phoneNumberController =
//         TextEditingController(text: address.phoneNumber);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Address'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//               ),
//               TextField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//               ),
//               TextField(
//                 controller: _countryNameController,
//                 decoration: const InputDecoration(labelText: 'Country'),
//               ),
//               TextField(
//                 controller: _cityNameController,
//                 decoration: const InputDecoration(labelText: 'City'),
//               ),
//               TextField(
//                 controller: _phoneNumberController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final updatedAddress = address.copyWith(
//                   firstName: _firstNameController.text,
//                   lastName: _lastNameController.text,
//                   countryName: _countryNameController.text,
//                   cityName: _cityNameController.text,
//                   phoneNumber: _phoneNumberController.text,
//                 );
//                 await addressProvider.addAddress(
//                     updatedAddress); // Use update method if necessary
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'package:e_commerce_app_flutter/utils/app_colors.dart';
// import 'package:e_commerce_app_flutter/utils/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:e_commerce_app_flutter/provider/address_provider.dart';
// import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
//
// class AddressBookPage extends StatelessWidget {
//   const AddressBookPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final addressProvider = Provider.of<AddressProvider>(context);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (addressProvider.state == AddressState.initial) {
//         addressProvider.loadAddressData();
//         // print(addressProvider.loadAddressData());
//         print(addressProvider.addressItems.length.toString());
//       }
//     });
//     return SafeArea(
//       child: Scaffold(
//         body: RefreshIndicator(
//           onRefresh: () async {
//             await addressProvider.loadAddressData();
//           },
//           child: Stack(
//             children: [
//               if (addressProvider.state == AddressState.loading)
//                 const Center(child: CircularProgressIndicator.adaptive())
//               else if (addressProvider.state == AddressState.error)
//                 Center(child: Text('Error: ${addressProvider.errorMessage}'))
//               else
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0, vertical: 16.0),
//                   child: GridView.builder(
//                     itemCount: addressProvider.addressItems.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 18,
//                     ),
//                     itemBuilder: (context, index) => Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.gray1,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child:
//                           Text(addressProvider.addressItems.length.toString()),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:e_commerce_app_flutter/provider/address_provider.dart';
// import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
// import 'package:e_commerce_app_flutter/utils/app_colors.dart';
//
// class AddressBookPage extends StatefulWidget {
//   const AddressBookPage({super.key});
//
//   @override
//   State<AddressBookPage> createState() => _AddressBookPageState();
// }
//
// class _AddressBookPageState extends State<AddressBookPage> {
//   @override
//   Widget build(BuildContext context) {
//     // Wrap the Scaffold with Consumer for addressProvider
//     return Consumer<AddressProvider>(
//       builder: (context, addressProvider, child) {
//         // Load data if the state is initial
//         if (addressProvider.state == AddressState.initial) {
//           addressProvider.loadAddressData();
//         }
//
//         return SafeArea(
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('Address Book'),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     // Add action for adding address
//                     _showAddAddressDialog(context);
//                   },
//                 ),
//               ],
//             ),
//             body: RefreshIndicator(
//               onRefresh: () async {
//                 await addressProvider.loadAddressData();
//               },
//               child: Stack(
//                 children: [
//                   if (addressProvider.state == AddressState.loading)
//                     const Center(child: CircularProgressIndicator.adaptive())
//                   else if (addressProvider.state == AddressState.error)
//                     Center(
//                         child: Text('Error: ${addressProvider.errorMessage}'))
//                   else if (addressProvider.addressItems.isEmpty)
//                     const Center(child: Text('No addresses available.'))
//                   else
//                     SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 16.0),
//                       child: GridView.builder(
//                         itemCount: addressProvider.addressItems.length,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 18,
//                         ),
//                         itemBuilder: (context, index) {
//                           final address = addressProvider.addressItems[index];
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.gray1,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   address.firstName, // Adjust as needed
//                                   //style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                                 Text(
//                                   address.cityName, // Adjust as needed
//                                   //style: Theme.of(context).textTheme.bodyText2,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showAddAddressDialog(BuildContext context) {
//     // Implement dialog to add address
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/provider/address_provider.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  late AddressProvider addressProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addressProvider = Provider.of<AddressProvider>(context);

    // Load address data only if the state is initial
    if (addressProvider.state == AddressState.initial) {
      addressProvider.loadAddressData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Address Book'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add action for adding address
                _showAddAddressDialog(context);
              },
            ),
          ],
        ),
        body: Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await addressProvider.loadAddressData();
              },
              child: Stack(
                children: [
                  if (addressProvider.state == AddressState.loading)
                    const Center(child: CircularProgressIndicator.adaptive())
                  else if (addressProvider.state == AddressState.error)
                    Center(
                        child: Text('Error: ${addressProvider.errorMessage}'))
                  else if (addressProvider.addressItems.isEmpty)
                    const Center(child: Text('No addresses available.'))
                  else
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      child: GridView.builder(
                        itemCount: addressProvider.addressItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 18,
                        ),
                        itemBuilder: (context, index) {
                          final address = addressProvider.addressItems[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.gray1,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.firstName, // Adjust as needed
                                  // style: Theme.of(context).textTheme.,
                                ),
                                Text(
                                  address.cityName, // Adjust as needed
                                  // style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    // Implement dialog to add address
  }
}
