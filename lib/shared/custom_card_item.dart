import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomCardItem extends StatelessWidget {
  const CustomCardItem({
    super.key,
    required this.img,
    required this.text,
    required this.des,
    required this.rate,
  });
  final String img, text, des, rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(img, width: 180, height: 110),
            CustomText(
              text: text,
              weight: FontWeight.bold,
              size: 14,
              color: Colors.black,
            ),
            CustomText(
              text: des,
              weight: FontWeight.w400,
              size: 12,
              color: Colors.black87,
            ),
            SizedBox(
              width: 145,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(rate, style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(CupertinoIcons.heart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
