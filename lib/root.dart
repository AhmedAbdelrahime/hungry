import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/view/profile_view.dart';
import 'package:hungry/features/cart/view/cart_view.dart';
import 'package:hungry/features/home/view/home_view.dart';
import 'package:hungry/features/proudect/orderd_history_view.dart';
import 'package:hungry/shared/custom_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  // late PageController pageController = PageController();
  late List<Widget> screens;
  int currentpage = 0;
  bool isGuest = false;
  AuthRepo authRepo = AuthRepo();

  bool isloadinglogout = false;

  UserModel? userModel;
  // Future<void> getProfileData() async {
  //   try {
  //     final user = await authRepo.getProfileData();
  //     setState(() {
  //       userModel = user;
  //     });
  //   } catch (e) {
  //     String errorMsg = 'Error in profile';
  //     ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
  //   }
  // }

  Future<void> autologin() async {
    try {
      final user = await authRepo.autoLogin();
      setState(() {
        isGuest = authRepo.isGuest;
      });
      if (user != null) {
        setState(() {
          userModel = user;
        });
      }
    } catch (e) {
      String errorMsg = 'Error in profile';
      // ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
    }
  }

  Future<void> logout() async {
    try {
      setState(() => isloadinglogout = true);

      await authRepo.logout();
      if (!mounted) return;
      setState(() => isloadinglogout = false);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginView();
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isloadinglogout = false);

      String errMsg = 'Failed to logout';
      if (e is ApiError) errMsg = e.message;

      ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errMsg));
    }
  }

  @override
  void initState() {
    autologin();
    // getProfileData();
    screens = [HomeView(), CartView(), OrderdHistoryView(), ProfileView()];
    // pageController = PageController(initialPage: currentpage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: IndexedStack(index: currentpage, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(20),
          ),
        ),
        child: isGuest
            ? CustomBtn(text: 'Try to LogIn ', ontap: () => logout())
            : isloadinglogout
            ? CupertinoActivityIndicator(color: AppColors.primaryColor)
            : BottomNavigationBar(
                currentIndex: currentpage,

                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black45,

                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  setState(() {
                    currentpage = value;
                  });
                  // pageController.jumpToPage(value);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cart),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_restaurant_sharp),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person_fill),
                    label: 'Profile',
                  ),
                ],
              ),
      ),
    );
  }
}
