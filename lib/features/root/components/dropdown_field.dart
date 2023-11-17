import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final Function(String) onChanged;
  final bool isEnabled;
  final String page, labelText;
  final Icon icon;
  const DropdownField({
    super.key,
    required this.onChanged,
    required this.isEnabled,
    required this.page,
    required this.labelText,
    required this.icon,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? selectedValue;
  final List<String> dropdownItems = [
    'Kampus 1',
    'Kampus 2',
    'Kampus 3',
    'Kampus 4',
    'Kampus 5',
    'Kampus 6',
  ];
  final List<String> jabatan = [
    'Dosen',
    "Karyawan",
    "Mahasiswa",
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        enableFeedback: widget.isEnabled,
        value: selectedValue,
        items: widget.page == "pembuatan_laporan"
            ? dropdownItems.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList()
            : jabatan.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged(selectedValue!);
        },
        decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: widget.icon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16)));
  }
}
