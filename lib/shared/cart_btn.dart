import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class CartBtn extends StatelessWidget {
  const CartBtn({
    super.key,
    required this.ontap,
    required this.text,
    this.width = 200,
    this.color = AppColors.primaryColor,
    this.hight = 60,
  });
  final GestureTapCallback ontap;
  final String text;
  final double width;
  final double hight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: width,
        height: hight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: text,
            color: Colors.white,
            weight: FontWeight.bold,
            size: 20,
          ),
        ),
      ),
    );
  }
}
