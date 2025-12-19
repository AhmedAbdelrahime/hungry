import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_text.dart';

class CheckoutText extends StatelessWidget {
  const CheckoutText({
    super.key,
    required this.text,
    required this.price,
    this.wight = FontWeight.normal,
    this.color = Colors.grey,
    this.size = 16,
  });
  final String text;
  final String price;
  final FontWeight wight;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          CustomText(text: text, size: size, color: color, weight: wight),
          Spacer(),
          CustomText(text: price, size: size, color: color, weight: wight),
        ],
      ),
    );
  }
}
