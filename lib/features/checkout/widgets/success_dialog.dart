import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/cart_btn.dart';
import 'package:hungry/shared/custom_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(40),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.check,
                weight: 100,
                size: 80,
                color: Colors.white,
              ),
            ),
            Gap(10),
            CustomText(
              text: 'Success',
              color: AppColors.primaryColor,
              weight: FontWeight.bold,
              size: 24,
            ),
            Gap(10),
            Center(
              child: CustomText(
                text:
                    'Your payment was successful. \nA receit for this purchase has\n been sent to your email.',
                color: Colors.grey,
                weight: FontWeight.w400,
                size: 18,
              ),
            ),
            Gap(20),
            CartBtn(
              width: double.infinity,
              ontap: () => Navigator.pop(context),
              text: 'Go Back',
            ),
          ],
        ),
      ),
    );
  }
}
