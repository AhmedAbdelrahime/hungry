import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/shared/custom_text.dart';

class EditItemCart extends StatelessWidget {
  const EditItemCart({
    super.key,

    required this.onRemove,
    required this.image,
    required this.name,
    required this.price,
    required this.isloading,
    required this.toppings,
    required this.sideoptions,
    required this.quntity,
  });

  final VoidCallback onRemove;
  final String image;
  final String name;
  final String price;
  final int quntity;
  final bool isloading;
  final List<Toppings> toppings;
  final List<Toppings> sideoptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),

        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(image, width: 140, height: 100),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: name, weight: FontWeight.w700),
                        Row(
                          children: [
                            CustomText(
                              text: price,
                              weight: FontWeight.w600,
                              size: 16,
                              color: Colors.black87,
                            ),
                            CustomText(
                              text: ' X  $quntity Pieces ',
                              weight: FontWeight.w600,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Gap(20),
                        Row(
                          children: List.generate(toppings.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: AppColors.primaryColor,

                                child: Image.network(toppings[index].image),
                              ),
                            );
                          }),
                        ),
                        Gap(10),
                        Row(
                          children: List.generate(sideoptions.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: AppColors.primaryColor,

                                child: Image.network(sideoptions[index].image),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 10),
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 110,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: isloading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : CustomText(
                                  text: 'Remove',
                                  size: 18,
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
