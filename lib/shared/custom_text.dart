import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.weight,
    this.size,
    this.color,
    this.overflow = TextOverflow.ellipsis,
  });
  final String text;
  final FontWeight? weight;
  final double? size;
  final Color? color;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      textScaler: TextScaler.linear(1.0),
      maxLines: 2,

      overflow: overflow,

      text,
      style: TextStyle(color: color, fontSize: size, fontWeight: weight),
    );
  }
}
