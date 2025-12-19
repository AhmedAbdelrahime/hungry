import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.onChanged});

  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      borderRadius: BorderRadius.circular(15),
      shadowColor: Colors.grey,
      child: TextField(
        cursorColor: AppColors.primaryColor,
        cursorWidth: 2,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,

          fillColor: AppColors.backgroundColor,
          prefixIcon: Icon(Icons.search, size: 24, color: Colors.grey),
          hintText: 'Search...',
          hintStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
