import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/services/address_services.dart';

enum AddressState { initial, loading, loaded, error }

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addressItems = [];
  AddressState _state = AddressState.initial;
  String _errorMessage = '';
  final addressServices = AddressServicesImpl();
  String? _selectedAddressId;
  //Address? _selectedAddress;

//  Address? get selectedAddress => _selectedAddress;
  List<AddressModel> get addressItems => _addressItems;
  AddressState get state => _state;
  String get errorMessage => _errorMessage;
  String? get selectedAddressId => _selectedAddressId;

  Future<void> loadAddressData() async {
    _state = AddressState.loading;
    notifyListeners();
    try {
      final fetchedAddresses = await addressServices.getAddressItems();
      _addressItems = fetchedAddresses;
      _state = AddressState.loaded;
    } catch (error) {
      _state = AddressState.error;
      _errorMessage = error.toString();
    }
    notifyListeners();
  }

  Future<void> addAddress(AddressModel addressModel) async {
    try {
      await addressServices.addAddress(addressModel);
      _addressItems.add(addressModel);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
      notifyListeners();
    }
  }

  // Future<void> updateAddress(AddressModel addressModel) async {
  //   try {
  //     await addressServices.updateAddress(addressModel);
  //     final index =
  //         _addressItems.indexWhere((address) => address.id == addressModel.id);
  //     if (index != -1) {
  //       _addressItems[index] = addressModel;
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     _errorMessage = error.toString();
  //     _state = AddressState.error;
  //     notifyListeners();
  //   }
  // }

  void chooseAddress(String addressId) {
    // _selectedAddress = _addressItems.firstWhere((item) => item.id == addressId);
    _selectedAddressId = addressId;
    notifyListeners();
  }

  Future<void> removeAddress(String addressId) async {
    try {
      await addressServices.removeAddress(addressId);
      _addressItems.removeWhere((address) => address.id == addressId);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
      notifyListeners();
    }
  }
}
