import 'package:flutter/material.dart';

class CampusSelection extends StatefulWidget {
  final Function(String) onChanged;
  final bool isEnabled;
  const CampusSelection({
    super.key,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  State<CampusSelection> createState() => _CampusSelectionState();
}

class _CampusSelectionState extends State<CampusSelection> {
  String? selectedValue;

  final List<String> dropdownItems = [
    'Kampus 1',
    'Kampus 2',
    'Kampus 3',
    'Kampus 4',
    'Kampus 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: DropdownButtonFormField<String>(
        enableFeedback: widget.isEnabled,
        value: selectedValue,
        items: dropdownItems.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged(selectedValue!);
        },
        decoration: InputDecoration(
          labelText: 'Pilih kampus',
          prefixIcon: const Icon(Icons.apartment_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
