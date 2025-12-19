import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/checkout/view/checkout_view.dart';
import 'package:hungry/shared/cart_btn.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/edit_item_cart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final int itemCount = 20;
  late List<int> quntites;
  bool isLoadingRemove = false;
  List<Toppings> toppings = [];
  List<Toppings> options = [];
  int? removingItemId; // null = مفيش عنصر بيتحذف

  CartRepo cartRepo = CartRepo();

  GetCartResponseModel? cartData;

  Future<void> getCartData() async {
    try {
      final response = await cartRepo.getCartData();
      if (!mounted) return;

      setState(() {
        cartData = response;

        quntites = List.generate(
          response.data.items.length,
          (index) => response.data.items[index].quantity,
        );
      });
      // toppings = response.data.items[0].toppings;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      setState(() {
        removingItemId = itemId; // نحدد العنصر اللي بيتحذف
      });

      await cartRepo.removeFromCart(itemId);
      await getCartData(); // تحديث الكارت بعد الحذف
    } catch (e) {
      print(e);
    } finally {
      if (!mounted) return;
      setState(() {
        removingItemId = null; // نوقف اللودينج
      });
    }
  }

  double get totalPrice {
    if (cartData == null || cartData!.data.items.isEmpty) return 0.0;

    double total = 0.0;
    for (int i = 0; i < cartData!.data.items.length; i++) {
      final item = cartData!.data.items[i];
      final quantity = quntites[i];

      total += double.parse(item.price) * quantity;
    }
    return total;
  }

  @override
  void initState() {
    getCartData();

    // quntites = List.generate(itemCount, (index) => 1);
    super.initState();
  }

  // int itemNum = 1;

  void onAdd(int index) async {
    setState(() {
      quntites[index]++;
    });

    try {
      final itemId = cartData!.data.items[index].itemid;
      await cartRepo.updateQuantity(itemId, quntites[index]);
    } catch (e) {
      // لو فيه خطأ نرجع العدد زي ما كان
      setState(() {
        quntites[index]--;
      });
      print(e);
    }
  }

  void onMin(int index) async {
    if (quntites[index] > 1) {
      setState(() {
        quntites[index]--;
      });

      try {
        final itemId = cartData!.data.items[index].itemid;
        await cartRepo.updateQuantity(itemId, quntites[index]);
      } catch (e) {
        setState(() {
          quntites[index]++;
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: getCartData,
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        displacement: 20,

        child: Skeletonizer(enabled: cartData == null,
         child: _buildCartList()),
        // : cartData!.data.items.isEmpty
        // ? _buildEmptyCart()
        // : _buildCartList(),
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
        child: Skeletonizer(
          enabled: cartData == null,
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
                      text: '\$$totalPrice ',
                      color: Colors.black,
                      weight: FontWeight.bold,
                      size: 24,
                    ),
                  ],
                ),
                Spacer(),
                CartBtn(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CheckoutView(
                            totalPrice: totalPrice.toString(),
                            cartData: cartData!,
                          );
                        },
                      ),
                    );
                  },
                  text: 'Checkout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return SingleChildScrollView(
      // physics: const BouncingScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(), // 👈 الحل
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            const Gap(16),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartData?.data.items.length ?? 0,

            itemBuilder: (context, index) {
              final item = cartData!.data.items[index];
              final toppings = item.toppings;
              final options = item.options;
              final isRemoving = removingItemId == item.itemid;

              // setState(() {
              //   isLoadingRemove = isRemoving;
              // });

              return EditItemCart(
                // number: quntites[index],
                // onAdd: () => onAdd(index),
                // onMin: () => onMin(index),
                onRemove: () => removeFromCart(item.itemid),
                image: item.image,
                name: item.name,
                price: ' \$${item.price} ',
                isloading: isRemoving,
                toppings: toppings,
                sideoptions: options,
                quntity: quntites[index],
              );
            },
          ),
        ),
        Gap(100),
      ],
    );
  }
}
