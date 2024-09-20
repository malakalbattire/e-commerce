import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_flutter/models/address_model/address_model.dart';
import 'package:e_commerce_app_flutter/services/address_services.dart';
import 'package:flutter/material.dart';

enum AddressState { initial, loading, loaded, error }

class AddressProvider with ChangeNotifier {
  late final TextEditingController lastNameController;
  late final TextEditingController firstNameController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController countryNameController;
  late final TextEditingController cityNameController;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late final FocusNode lastNameFocusNode;
  late final FocusNode firstNameFocusNode;
  late final FocusNode phoneNumberFocusNode;
  late final FocusNode countryNameFocusNode;
  late final FocusNode cityNameFocusNode;

  List<AddressModel> _addressItems = [];
  AddressState _state = AddressState.initial;
  String _errorMessage = '';
  final AddressServicesImpl _addressServices = AddressServicesImpl();
  String? _selectedAddress;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<AddressModel> get addressItems => _addressItems;
  AddressState get state => _state;
  String get errorMessage => _errorMessage;
  String? get selectedAddress => _selectedAddress;

  AddressProvider() {
    _initializeControllers();
  }
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _initializeControllers() {
    lastNameController = TextEditingController();
    firstNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    countryNameController = TextEditingController();
    cityNameController = TextEditingController();

    lastNameFocusNode = FocusNode();
    firstNameFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    countryNameFocusNode = FocusNode();
    cityNameFocusNode = FocusNode();
  }

  Future<void> submitAddress() async {
    if (lastNameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        countryNameController.text.isNotEmpty &&
        cityNameController.text.isNotEmpty) {
      final address = AddressModel(
        id: DateTime.now().toIso8601String(),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneNumberController.text,
        countryName: countryNameController.text,
        cityName: cityNameController.text,
        userId: userId,
      );

      try {
        await addAddress(address);
        _state = AddressState.loaded;
      } catch (e) {
        _errorMessage = e.toString();
        _state = AddressState.error;
      }
    } else {
      _errorMessage = 'Please fill in all fields';
      _state = AddressState.error;
    }
    notifyListeners();
  }

  Future<void> loadAddressData(String userId) async {
    _state = AddressState.loading;
    notifyListeners();
    try {
      final fetchedAddresses = await _addressServices.getAddressItems(userId);
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
      await _addressServices.addAddress(addressModel);
      _addressItems.add(addressModel);
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
    }
    notifyListeners();
  }

  void chooseAddress(String addressId) {
    _selectedAddress = addressId;
    notifyListeners();
  }

  Future<void> clearAddresses() async {
    try {
      lastNameController.clear();
      firstNameController.clear();
      phoneNumberController.clear();
      countryNameController.clear();
      cityNameController.clear();
      _addressItems.clear();
      _state = AddressState.initial;
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
    }
    notifyListeners();
  }

  Future<void> removeAddress(String addressId) async {
    try {
      await _addressServices.removeAddress(addressId);
      _addressItems.removeWhere((address) => address.id == addressId);
    } catch (error) {
      _errorMessage = error.toString();
      _state = AddressState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    phoneNumberController.dispose();
    countryNameController.dispose();
    cityNameController.dispose();

    lastNameFocusNode.dispose();
    firstNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    countryNameFocusNode.dispose();
    cityNameFocusNode.dispose();

    super.dispose();
  }
}
