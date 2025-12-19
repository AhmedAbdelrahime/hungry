import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';

class SingupView extends StatefulWidget {
  const SingupView({super.key});

  @override
  State<SingupView> createState() => _SingupViewState();
}

class _SingupViewState extends State<SingupView> {
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController nameControler = TextEditingController();
  final TextEditingController passControler = TextEditingController();
  bool isloading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthRepo authRepo = AuthRepo();

  @override
  void dispose() {
    nameControler.dispose();
    emailControler.dispose();
    passControler.dispose();
    super.dispose();
  }

  Future<void> singUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        final user = await authRepo.singUp(
          emailControler.text.trim(),
          passControler.text.trim(),
          nameControler.text.trim(),
        );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Root();
              },
            ),
          );
        }
        setState(() {
          isloading = false;
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          isloading = false;
        });
        String errormsg = 'unexpected singUp';
        if (e is ApiError) {
          errormsg = e.message;
          print(errormsg);
          ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errormsg));
        }
      }
    }
  }

  @override
  void initState() {
    // emailControler.text = 'ahmed@tiktok.com';
    // passControler.text = 'Jaq00121';
    // nameControler.text = 'ahmed';
    // TODO: implement initState
    super.initState();
  }
  // void singUp() async {
  //   if (!_formKey.currentState!.validate())
  //     return print(' not Sing Up successfuly');
  //   setState(() {
  //     isloading = true;
  //   });

  //   await Future.delayed(Duration(seconds: 2));
  //   setState(() {
  //     isloading = false;
  //   });
  //   print('Sing Up successfuly');
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backgroundColor,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap(100),
              Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/logo/Hungry_ (2).svg',
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(10),
                  CustomText(
                    text: 'Welcome  to Hungry!',
                    weight: FontWeight.w700,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  Gap(50),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.grey.shade700,
                        offset: Offset(0, 1),
                      ),
                    ],
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hinttext: 'Enter your  Name ',
                        controller: nameControler,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }

                          if (value.length > 50) {
                            return 'Name cannot be more than 50 characters';
                          }

                          return null;
                        },
                      ),
                      Gap(15),

                      CustomTextFormField(
                        hinttext: ' Enter your Email ',
                        keyboardType: TextInputType.emailAddress,

                        controller: emailControler,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Email must contain @ symbol';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          if (value.length > 50) {
                            return 'Email cannot be more than 50 characters';
                          }
                          if (value.length < 5) {
                            return 'Email must be at least 5 characters';
                          }
                          return null;
                        },
                      ),
                      Gap(15),

                      CustomTextFormField(
                        hinttext: ' Enter your password ',
                        keyboardType: TextInputType.visiblePassword,

                        controller: passControler,

                        ispassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (value.length > 20) {
                            return 'Password cannot be more than 20 characters';
                          }
                          return null;
                        },
                      ),
                      Gap(15),

                      Gap(30),
                      isloading
                          ? CupertinoActivityIndicator(
                              animating: true,
                              color: AppColors.backgroundColor,
                              radius: 20,
                            )
                          : CustomBtn(text: 'Sing Up', ontap: singUp),
                      Gap(20),
                      Row(
                        children: [
                          CustomText(
                            text: 'Alredy Have Account ?',
                            weight: FontWeight.w500,
                            color: AppColors.backgroundColor,
                            size: 16,
                          ),
                          Gap(10),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginView();
                                  },
                                ),
                              );
                            },
                            child: CustomText(
                              text: 'Login',
                              weight: FontWeight.w600,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
