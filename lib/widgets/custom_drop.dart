import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<CountryForAddress> countries;
  final CountryForAddress selectedCountry;
  final Function(CountryForAddress) onCountryChanged;

  CustomDropdown({
    Key? key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountryChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late CountryForAddress currentSelectedValue;

  @override
  void initState() {
    super.initState();
    currentSelectedValue = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CountryForAddress>(
      value: currentSelectedValue,
      onChanged: (CountryForAddress? newValue) {
        if (newValue != null) {
          setState(() {
            currentSelectedValue = newValue;
          });
          widget.onCountryChanged(newValue);
        }
      },
      items: widget.countries.map<DropdownMenuItem<CountryForAddress>>((CountryForAddress country) {
        return DropdownMenuItem<CountryForAddress>(
          value: country,
          child: Text(country.name),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a country';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Select Country',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class CountryForAddress {
  final int id;
  final String name;

  CountryForAddress({required this.id, required this.name});

  // Factory method to create a CountryForAddress from JSON.
  factory CountryForAddress.fromJson(Map<String, dynamic> json) {
    return CountryForAddress(
      id: json['id'],
      name: json['name'],
    );
  }

  // Override == and hashCode to correctly compare instances.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CountryForAddress &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
