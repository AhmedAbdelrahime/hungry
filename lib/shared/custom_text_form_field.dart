import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.ispassword = false,
    required this.hinttext,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.fillColor = AppColors.backgroundColor,
    this.cursorColor = AppColors.primaryColor,
    this.hintColor, this.textColor, this.iconColor,
  });
  final bool ispassword;
  final String hinttext;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Color? cursorColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obsecureText;

  @override
  void initState() {
    _obsecureText = widget.ispassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: widget.textColor,
      ),
      controller: widget.controller,
      obscureText: _obsecureText,
      validator: widget.validator,
      cursorColor: widget.cursorColor,
      cursorWidth: 2,
      keyboardType: widget.keyboardType,

      decoration: InputDecoration(
        suffixIcon: widget.ispassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obsecureText = !_obsecureText;
                  });
                },

                child: _obsecureText
                    ? Icon(Icons.visibility_outlined , color: widget.iconColor, )
                    : Icon(Icons.visibility_off_outlined, color: widget.iconColor,),
              )
            : null,
        hintText: widget.hinttext,
        
        hintStyle: TextStyle(color: widget.hintColor),

        fillColor: widget.fillColor,
        filled: true,
        border: OutlineInputBorder(

          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   borderSide: BorderSide(color: AppColors.backgroundColor),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   borderSide: BorderSide(color: AppColors.backgroundColor),
        // ),
      ),
    );
  }
}
