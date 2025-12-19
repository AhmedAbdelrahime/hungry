import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/view/cart_view.dart';
import 'package:hungry/features/home/data/models/toppings_model.dart';
import 'package:hungry/features/home/data/repos/proudect_repo.dart';
import 'package:hungry/shared/cart_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/toppings_card.dart';
import 'package:hungry/shared/update_quntity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProudectView extends StatefulWidget {
  const ProudectView({
    super.key,
    required this.imageurl,
    required this.name,
    required this.desc,
    required this.id,
    required this.price,
  });
  final String imageurl;
  final String name;
  final String desc;
  final int id;
  final String price;

  @override
  State<ProudectView> createState() => _ProudectViewState();
}

class _ProudectViewState extends State<ProudectView> {
  double sliderValue = .5;
  ProudectRepo proudectRepo = ProudectRepo();
  CartRepo cartRepo = CartRepo();

  List<ToppingsModel> toppings = [];
  List<ToppingsModel> sideOptions = [];
  List<int> selectedToppings = [];
  List<int> selectedSideOptions = [];
  int quntity = 1;

  bool isLoaded = false;
  bool isLoadedAddToCart = false;
  Future<void> getToppings() async {
    final res = await proudectRepo.getToppings();

    setState(() {
      isLoaded = true;
      toppings = res;
    });
  }

  Future<void> getSideOptions() async {
    final res = await proudectRepo.getSideOptions();

    setState(() {
      isLoaded = true;
      sideOptions = res;
    });
  }

  //cart function
  Future<void> addToCart() async {
    try {
      setState(() {
        isLoadedAddToCart = true;
      });
      final cartItem = CartModel(
        productid: widget.id,
        quntity: quntity,
        spicys: sliderValue,
        toppings: selectedToppings,
        options: selectedSideOptions,
      );

      await cartRepo.addToCartData(CartRequestModel(cartItems: [cartItem]));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnakBar('Added to cart', color: Colors.green));
      print(cartItem.toJson());
      setState(() {
        isLoadedAddToCart = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CartView();
          },
        ),
      );
    } catch (e) {
      setState(() {
        isLoadedAddToCart = false;
      });
      throw ApiError(message: e.toString());
    }
  }

  void onAdd() {
    setState(() {
      quntity++;
    });
  }

  void onMin() {
    if (quntity > 1) {
      setState(() {
        quntity--;
      });
    }
  }

  @override
  void initState() {
    getToppings();
    getSideOptions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Image.network(widget.imageurl, width: 180),
                    Gap(10),
                    CustomText(
                      text: 'Quntity',
                      weight: FontWeight.bold,
                      size: 16,
                    ),
                    UpdateQuntity(number: quntity, onAdd: onAdd, onMin: onMin),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: CustomText(
                          text: widget.name,
                          weight: FontWeight.bold,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: CustomText(
                          text: widget.desc,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      CustomText(
                        text: 'Spicy ',
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                      Slider(
                        activeColor: AppColors.primaryColor,
                        value: sliderValue,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                            print(value);
                          });
                        },
                      ),
                      Row(
                        children: [
                          Icon(Icons.hot_tub_outlined, color: Colors.red),
                          Gap(100),
                          Icon(Icons.cloud, color: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(50),

            CustomText(text: 'Toppings', weight: FontWeight.bold, size: 20),
            Skeletonizer(
              enabled: !isLoaded,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: toppings.length,

                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, index) {
                    final topping = toppings[index];
                    final isSelected = selectedToppings.contains(topping.id);

                    return ToppingsCard(
                      image: topping.image,
                      name: topping.name,
                      isSelected: isSelected,
                      ontap: () {
                        setState(() {
                          if (isSelected) {
                            selectedToppings.remove(topping.id);
                          } else {
                            selectedToppings.add(topping.id);
                          }
                          print(selectedToppings);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Gap(30),

            CustomText(text: 'Side options', weight: FontWeight.bold, size: 20),
            Skeletonizer(
              enabled: !isLoaded,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: sideOptions.length,

                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, index) {
                    final sideOption = sideOptions[index];
                    final isSelected = selectedSideOptions.contains(
                      sideOption.id,
                    );

                    return ToppingsCard(
                      ontap: () {
                        setState(() {
                          if (isSelected) {
                            selectedSideOptions.remove(sideOption.id);
                          } else {
                            selectedSideOptions.add(sideOption.id);
                          }
                        });
                        print(selectedSideOptions);
                      },
                      image: sideOption.image,
                      name: sideOption.name,
                      isSelected: selectedSideOptions.contains(sideOption.id),
                    );
                  },
                ),
              ),
            ),

            Gap(100),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ],
        ),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Total',
                    color: Colors.black,
                    weight: FontWeight.w600,
                    size: 18,
                  ),
                  CustomText(
                    text:
                        '\$${(double.parse(widget.price) * quntity).toStringAsFixed(2)}',
                    color: Colors.black,
                    weight: FontWeight.bold,
                    size: 24,
                  ),
                ],
              ),
              Spacer(),
              isLoadedAddToCart
                  ? Padding(
                      padding: const EdgeInsets.only(right: 50, top: 10),
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                        radius: 20,
                      ),
                    )
                  : CartBtn(ontap: addToCart, text: 'Add To Cart'),
            ],
          ),
        ),
      ),
    );
  }
}
