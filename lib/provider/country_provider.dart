import 'package:countries1/services/api_services.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';


class CountryProvider with ChangeNotifier {
  List<Country>? _countries = [];
  List<Country>? _savedCountries = [];

  List<Country>? get countries => _countries;
  List<Country>? get savedCountries => _savedCountries;

  final ApiService _countryApi = ApiService();

  Future<void> fetchCountries() async {
    try {
      _countries = await _countryApi.getAllCountries();
      notifyListeners();
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }

  void addToSaved(Country country) {
    _savedCountries?.add(country);
    notifyListeners();
  }

  void removeFromSaved(Country country) {
    _savedCountries?.remove(country);
    notifyListeners();
  }
}
