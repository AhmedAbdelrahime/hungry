import 'package:flutter/material.dart';
import 'package:hungry/shared/cart_btn.dart';
import 'package:hungry/shared/custom_text.dart';

class HistoryCart extends StatelessWidget {
  const HistoryCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 10,
            color: Colors.white,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/1.png', width: 140),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Hamburger ',
                                weight: FontWeight.w700,
                              ),
                              CustomText(text: 'Qty :  x3'),
                              CustomText(text: 'Price : 20\$'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  CartBtn(
                    hight: 50,
                    width: double.infinity,
                    ontap: () {},
                    text: 'Reored',
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
  }
}