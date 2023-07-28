import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailPage extends StatefulWidget {
  final Country country;
  final bool isCountrySaved;
  final Function(Country country) onToggleSaved;

  const CountryDetailPage({
    required this.country,
    required this.isCountrySaved,
    required this.onToggleSaved,
  });

  @override
  _CountryDetailPageState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  bool _isCountrySaved = false;

  @override
  void initState() {
    super.initState();
    _isCountrySaved = widget.isCountrySaved;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name?.common ?? 'Country Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Name'),
                    subtitle: Text(widget.country.name?.common ?? 'N/A'),
                  ),
                  ListTile(
                    title: Text('Capital'),
                    subtitle: Text(widget.country.capital != null && widget.country.capital!.isNotEmpty ? widget.country.capital!.first : 'N/A'),
                  ),
                  ListTile(
                    title: Text('Continent'),
                    subtitle: Text(
                      widget.country.continents != null && widget.country.continents!.isNotEmpty
                          ? widget.country.continents!.length == 1
                          ? widget.country.continents!.first
                          : widget.country.continents.toString()
                          : 'N/A',
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: widget.country.flags != null && widget.country.flags!.png != null
                  ? Image.network(
                widget.country.flags!.png!,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.flag_rounded),
            ),
            SizedBox(height: 16),
            Center(
              child: IconButton(
                icon: Icon(_isCountrySaved ? Icons.favorite : Icons.favorite_border, color: _isCountrySaved ? Colors.red : null),
                onPressed: _toggleSaved,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSaved() {
    setState(() {
      _isCountrySaved = !_isCountrySaved;
      widget.onToggleSaved(widget.country);
    });
  }
}
