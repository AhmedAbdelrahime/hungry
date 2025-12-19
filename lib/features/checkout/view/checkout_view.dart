import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/data/order_model.dart';
import 'package:hungry/features/cart/data/order_repo.dart';
import 'package:hungry/features/checkout/widgets/checkout_text.dart';
import 'package:hungry/features/checkout/widgets/success_dialog.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/cart_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.totalPrice,
    required this.cartData,
  });
  final String totalPrice;
  final GetCartResponseModel cartData;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selctedPyment = 'cash';
  bool checkbox = true;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();
  bool hasvisa = false;
  bool isLoadingProfile = true;
  OrderRepo orderRepo = OrderRepo();
  CartRepo cartRepo = CartRepo();

  bool isLoading = false;

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
        hasvisa = user?.visa?.isNotEmpty == true;
        selctedPyment = hasvisa ? 'visa' : 'cash';
        isLoadingProfile = false;
      });
    } catch (e) {
      isLoadingProfile = false;

      String errorMsg = 'Error in Checkout';

      // ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
    }
  }

  Future<void> creatorder() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// 1️⃣ تجهيز items للأوردر
      final List<OrderItemModel> items = widget.cartData.data.items.map((item) {
        return OrderItemModel(
          productId: item.productid,
          quantity: item.quantity,
          spicy: item.spicys,
          toppings: item.toppings.map((t) => t.id).toList(),
          sideOptions: item.options.map((t) => t.id).toList(),
        );
      }).toList();

      /// 2️⃣ إنشاء الأوردر
      await orderRepo.createOrder(OrderRequestModel(items: items));

      /// 3️⃣ تجهيز IDs عناصر الكارت
      final cartItemIds = widget.cartData.data.items
          .map((item) => item.itemid) // ⚠️ لازم يكون cart item id
          .toList();

      /// 4️⃣ مسح الكارت كله
      await cartRepo.removeAllFromCart(cartItemIds);

      /// 5️⃣ Success dialog
      showDialog(context: context, builder: (context) => const SuccessDialog());

      setState(() {
        isLoading = false;
      });

      /// 6️⃣ Navigate to Root
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Root()),
          (route) => false,
        );
      });
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnakBar('Error in Checkout'));
    }
  }

  // Future<void> removeAllFromCart() async {
  //   try {
  //     final items = List.from(widget.cartData.data.items);

  //     for (final item in items) {
  //       await cartRepo.removeFromCart(item.id);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    double total = double.parse(widget.totalPrice);
    int visa = userModel?.visa?.isNotEmpty == true ? 1 : 0;
    GetCartResponseModel cartData = widget.cartData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Skeletonizer(
          enabled: isLoadingProfile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Order summary',
                size: 20,
                weight: FontWeight.w700,
              ),
              CheckoutText(
                text: 'Order',
                price: 'Price (${cartData.data.items.length})',
              ),
              Column(
                children: List.generate(cartData.data.items.length, (index) {
                  return CheckoutText(
                    text: cartData.data.items[index].name,
                    price:
                        '\$${cartData.data.items[index].price} x ${cartData.data.items[index].quantity}',
                  );
                }),
              ),

              CheckoutText(text: 'Taxes', price: '\$0.65'),
              CheckoutText(text: 'Delivery fees', price: '\$5.85'),
              Divider(),
              CheckoutText(
                text: 'Total:',
                price: '\$${(total + 5.85 + 0.65).toStringAsFixed(2)}',
                size: 18,
                wight: FontWeight.bold,
                color: Colors.black,
              ),
              CheckoutText(
                size: 14,
                text: 'Estimated delivery time:',
                price: '15 - 30 mins',
                wight: FontWeight.w900,
                color: Colors.black,
              ),
              Gap(20),
              CustomText(
                text: 'Payment methods',
                size: 20,
                weight: FontWeight.w700,
              ),
              Gap(20),

              if (hasvisa == false)
                Material(
                  elevation: 15,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    tileColor: Colors.brown,
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primaryColor,
                      child: CustomText(
                        text: '\$',
                        size: 28,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    title: CustomText(
                      text: 'Cash on Delivery',
                      size: 20,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    trailing: Radio(
                      value: 'cash',
                      // ignore: deprecated_member_use
                      groupValue: selctedPyment,
                      activeColor: Colors.white,

                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        setState(() {
                          selctedPyment = value!;
                          print(value);
                        });
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 5,

                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/visa.png'),
                        Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Debit Card',
                              size: 14,
                              weight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            CustomText(
                              text: '${userModel?.visa}',
                              size: 14,
                              weight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Spacer(),
                        Radio(
                          value: 'visa',
                          // ignore: deprecated_member_use
                          groupValue: selctedPyment,
                          activeColor: Colors.black,

                          // ignore: deprecated_member_use
                          onChanged: (value) {
                            setState(() {
                              selctedPyment = value!;
                              print(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              Gap(20),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.redAccent,
                    value: checkbox,
                    onChanged: (value) {
                      setState(() {
                        checkbox = value!;
                      });
                    },
                  ),
                  CustomText(
                    text: 'Save card details for future payments',
                    size: 14,
                    weight: FontWeight.w400,
                    color: Colors.grey.shade800,
                  ),
                ],
              ),
            ],
          ),
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
                    text: 'Total price',
                    color: Colors.grey,
                    weight: FontWeight.w400,
                    size: 16,
                  ),
                  CustomText(
                    text:
                        '\$${(double.parse(widget.totalPrice) + 0.65 + 5.85).toStringAsFixed(2)}',
                    color: Colors.black,
                    weight: FontWeight.bold,
                    size: 24,
                  ),
                ],
              ),
              Spacer(),
              isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                        color: AppColors.primaryColor,
                      ),
                    )
                  : CartBtn(ontap: creatorder, text: 'Pay Now'),
            ],
          ),
        ),
      ),
    );
  }
}
