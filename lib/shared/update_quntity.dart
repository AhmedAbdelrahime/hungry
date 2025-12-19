import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class UpdateQuntity extends StatelessWidget {
  const UpdateQuntity({
    super.key,
    required this.number,
    required this.onAdd,
    required this.onMin,
  });
  final int number;
  final VoidCallback onAdd;
  final VoidCallback onMin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMin,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: CustomText(
                text: number.toString(),
                size: 18,
                weight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
