import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class TextfieledAuth extends StatefulWidget {
  const TextfieledAuth({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassowed = false, this.keyboardType,
  });
  final TextEditingController controller;
  final String labelText;
  final bool isPassowed;
  final TextInputType? keyboardType;

  @override
  State<TextfieledAuth> createState() => _TextfieledAuthState();
}

class _TextfieledAuthState extends State<TextfieledAuth> {
  late bool _obsecureText;
  @override
  void initState() {
    _obsecureText = widget.isPassowed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: _obsecureText,
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,

        decoration: InputDecoration(
          suffixIcon: widget.isPassowed
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obsecureText = !_obsecureText;
                    });
                  },

                  child: _obsecureText
                      ? Icon(Icons.visibility_outlined, color: Colors.white)
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.white,
                        ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.backgroundColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.backgroundColor),
            borderRadius: BorderRadius.circular(12),
          ),

          labelText: widget.labelText,

          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
