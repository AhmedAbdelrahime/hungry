import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/home/data/models/proudect_model.dart';
import 'package:hungry/shared/custom_text.dart';

class CategoryItems extends StatefulWidget {
  const CategoryItems({
    super.key,
    required this.selectedIndex,
    required this.cat,
  });
  final int selectedIndex;
  final List<CategoriesModel> cat;
  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cat.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? AppColors.primaryColor
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: CustomText(
                text: widget.cat[index].name,
                weight: FontWeight.w500,
                size: 16,
                color: selectedIndex == index
                    ? AppColors.backgroundColor
                    : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
