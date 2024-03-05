import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class OutlinedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hitText;
  final Widget icon;
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  final bool readOnly;
  final TextEditingController? slugController;
  final int maxLines;
  const OutlinedTextField(
      {super.key,
      required this.hitText,
      required this.icon,
      this.controller,
      this.margin,
      this.maxLines = 1,
      this.keyboardType,
      this.slugController,
      this.obscureText = false,
      this.readOnly = false, // Set default value for readOnly

      this.rigtIcon});

  String _generateSlug(String value) {
    // Logic to generate slug from name
    // For simplicity, you can replace spaces with hyphens
    return value.toLowerCase().replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly, // Pass readOnly value to TextField
      onChanged: (value) {
        if (hitText.toLowerCase() == 'name') {
          // If the field is for 'Name', generate slug when name changes
          final slug = _generateSlug(value);
          if (!readOnly) {
            // Set the slug value only if the field is not read-only
            slugController?.text = slug;
          }
        }
      },
      decoration: InputDecoration(
        fillColor: TColor.gray.withOpacity(0.1),
        hintText: hitText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: icon,
        suffixIcon: rigtIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: hitText,
        labelStyle: const TextStyle(color: Colors.blue, fontSize: 14),
      ),
    );
  }
}
