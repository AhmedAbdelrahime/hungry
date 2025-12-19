import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.text,
    required this.ontap,
    this.btncolor = AppColors.backgroundColor,
    this.textcolor = AppColors.primaryColor,
    this.widthText = 20,
    this.widthBtn = double.infinity,
    this.hightBtn = 50,
  });
  final String text;
  final VoidCallback ontap;
  final Color? btncolor;
  final Color? textcolor;
  final double? widthText;
  final double? widthBtn;
  final double? hightBtn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: widthBtn,
        height: hightBtn,
        decoration: BoxDecoration(
          color: btncolor,
          borderRadius: BorderRadius.circular( 5),
        ),
        child: Center(
          child: CustomText(
            text: text,
            weight: FontWeight.bold,
            size: widthText,
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
