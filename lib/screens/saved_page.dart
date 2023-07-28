import 'package:flutter/material.dart';
import '../models/country.dart';
import 'detail_page.dart';

class SavedPage extends StatefulWidget {
  final List<Country> savedCountries;
  final Function(List<Country>) onSavedCountriesChanged;

  SavedPage({required this.savedCountries, required this.onSavedCountriesChanged});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Countries'),
      ),
      body: getWidget(),
    );
  }

  Widget getWidget() {
    if (widget.savedCountries.isEmpty) {
      return Center(
        child: Text('No saved countries.'),
      );
    } else {
      return ListView.builder(
        itemCount: widget.savedCountries.length,
        itemBuilder: (context, index) {
          final country = widget.savedCountries[index];
          return ListTile(
            title: Text(country.name?.common ?? 'No name'),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
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
      widget.savedCountries.remove(country);
    });

    widget.onSavedCountriesChanged(widget.savedCountries);
  }

  void _navigateToCountryDetailPage(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailPage(
          country: country,
          isCountrySaved: true,
          onToggleSaved: _toggleSavedCountry,
        ),
      ),
    );
  }
}
