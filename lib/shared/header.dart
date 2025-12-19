import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.name, });
  final String name;

  @override
  Widget build(BuildContext context) {
    return    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/logo/Hungry_ (2).svg',
                        height: 40,
                        // ignore: deprecated_member_use
                        color: AppColors.primaryColor,
                      ),
                      CustomText(
                        text: 'Hello, $name',
                        weight: FontWeight.w500,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ],
                  );
  }
}