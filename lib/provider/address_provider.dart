import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/address_model.dart';
import 'package:e_commerce_app_flutter/services/address_services.dart';

enum AddressState { initial, loading, loaded, error }

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addressItems = [];
  AddressState _state = AddressState.initial;
  String _errorMessage = '';
  final AddressServices _addressServices = AddressServicesImpl();
  String? _selectedAddressId;

  List<AddressModel> get addressItems => _addressItems;
  AddressState get state => _state;
  String get errorMessage => _errorMessage;
  String? get selectedAddressId => _selectedAddressId;

  Future<void> loadAddressData() async {
    _state = AddressState.loading;
    notifyListeners();

    try {
      _addressItems = await _addressServices.getAddressItems();
      _state = AddressState.loaded;
    } catch (error) {
      _state = AddressState.error;
      _errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future<void> addAddress(AddressModel addressModel) async {
    try {
      await _addressServices.addAddress(addressModel);
      _addressItems.add(addressModel);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
      notifyListeners();
    }
  }

  void chooseAddress(String addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }

  Future<void> removeAddress(String addressId) async {
    try {
      await _addressServices.removeAddress(addressId);
      _addressItems.removeWhere((address) => address.id == addressId);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
      notifyListeners();
    }
  }
}
