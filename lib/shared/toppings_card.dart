import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class ToppingsCard extends StatelessWidget {
  const ToppingsCard({
    super.key,
    required this.image,
    required this.name,
    this.ontap,
    required this.isSelected,
  });
  final String image;
  final String name;
  final VoidCallback? ontap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Container(
              width: 90,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Image.network(image),
            ),
            Positioned(
              left: 3,
              bottom: 6,
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: CustomText(
                      text: name,
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Gap(8),
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: isSelected ? Colors.green : Colors.red,
                    child: Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: AppColors.backgroundColor,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
