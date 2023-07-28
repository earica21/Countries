//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/api_services.dart';
import 'detail_page.dart';
import 'saved_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country>? countries;
  List<Country>? initCountries;
  bool isLoading = true;
  bool showSearchField = false;

  Set<Country> savedCountries = Set();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countryService = ApiService();
    initCountries = await countryService.getAllCountries();
    setState(() {
      countries = initCountries;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Saved Countries',
        onPressed: navigateToSavedCountriesPage,
        child: const Icon(Icons.favorite),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: getWidget(),
        ),
      ),
    );
  }

  void searchCountry(String place) {
    if (initCountries != null) {
      setState(() {
        countries = initCountries!.where((c) =>
        c.name!.common!.toLowerCase().contains(place.toLowerCase()) ||
            (c.capital != null &&
                c.capital!.isNotEmpty &&
                c.capital!.first.toLowerCase().contains(place.toLowerCase())) ||
            (c.continents != null &&
                c.continents!.isNotEmpty &&
                c.continents!.first.toLowerCase().contains(place.toLowerCase())))
            .toList();
      });
    }
  }

  AppBar getAppBar() {
    return AppBar(
      title: Container(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text('Countries', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWidget() {
    if (countries == null || isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (countries!.isEmpty) {
      return const Center(
        child: Text('No country found!'),
      );
    } else {
      return ListView.builder(
        itemCount: countries!.length,
        itemBuilder: (context, index) {
          final country = countries![index];
          return ListTile(
            title: Text(country.name?.common ?? 'No name'),
            trailing: IconButton(
              icon: Icon(
                savedCountries.contains(country)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: savedCountries.contains(country) ? Colors.red : null,
              ),
              onPressed: () => _toggleSavedCountry(country),
            ),
            onTap: () => _navigateToCountryDetailPage(country),
          );
        },
      );
    }
  }

  void _toggleSavedCountry(Country country) {
    setState(() {
      if (savedCountries.contains(country)) {
        savedCountries.remove(country);
      } else {
        savedCountries.add(country);
      }
    });
  }

  void _navigateToCountryDetailPage(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailPage(
          country: country,
          isCountrySaved: savedCountries.contains(country),
          onToggleSaved: _toggleSavedCountry,
        ),
      ),
    );
  }

  void navigateToSavedCountriesPage() async {
    final updatedSavedCountries = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedPage(
          savedCountries: savedCountries.toList(),
          onSavedCountriesChanged: (updatedCountries) => setState(() {
            savedCountries = Set<Country>.from(updatedCountries);
          }),
        ),
      ),
    );

    if (updatedSavedCountries != null && updatedSavedCountries is List<Country>) {
      setState(() {
        savedCountries = Set<Country>.from(updatedSavedCountries);
      });
    }
  }
}
