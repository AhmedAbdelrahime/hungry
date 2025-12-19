import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/singup_view.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading = false;
  bool isloadingGuset = false;
  AuthRepo authRepo = AuthRepo();

  @override
  void dispose() {
    emailControler.dispose();
    passControler.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        final user = await authRepo.login(
          emailControler.text.trim(),
          passControler.text.trim(),
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
        setState(() {
          isloading = false;
        });
        String errormsg = 'unexpected login';
        if (e is ApiError) {
          errormsg = e.message;
          print(errormsg);
          ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errormsg));
        }
      }
    }
  }

  Future<void> loginGuset() async {
    setState(() {
      isloadingGuset = true;
    });
    try {
      final user = authRepo.continueAsGeust;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Root();
          },
        ),
      );
      setState(() {
        isloadingGuset = false;
      });
    } catch (e) {
      setState(() {
        isloadingGuset = false;
      });
      String errormsg = 'unexpected guset';
      if (e is ApiError) {
        errormsg = e.message;
        print(errormsg);
        ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errormsg));
      }
    }
  }

  @override
  void initState() {
    // emailControler.text = 'ahmed@tiktok.com';
    // passControler.text = 'Jaq00121';
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        backgroundColor: AppColors.primaryColor,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap(100),
              Center(child: SvgPicture.asset('assets/logo/Hungry_ (2).svg')),
              Gap(10),
              CustomText(
                text: 'Welcome Back to Hungry!',
                weight: FontWeight.w700,
                size: 15,
                color: AppColors.backgroundColor,
              ),
              Gap(60),

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
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Gap(50),
                      CustomTextFormField(
                        textColor: Colors.white,

                        hintColor: Colors.white70,
                        fillColor: AppColors.primaryColor,
                        cursorColor: AppColors.backgroundColor,
                        hinttext: 'Email ',
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
                      Gap(20),
                      CustomTextFormField(
                        hintColor: Colors.white70,
                        textColor: Colors.white,
                        iconColor: Colors.white,

                        fillColor: AppColors.primaryColor,
                        cursorColor: AppColors.backgroundColor,
                        hinttext: 'password ',
                        controller: passControler,
                        keyboardType: TextInputType.visiblePassword,

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
                      Gap(30),
                      isloading
                          ? CupertinoActivityIndicator(
                              animating: true,
                              color: AppColors.primaryColor,
                              radius: 20,
                            )
                          : CustomBtn(
                              btncolor: AppColors.primaryColor,
                              textcolor: AppColors.backgroundColor,
                              text: 'Login',
                              ontap: login,
                            ),
                      Gap(10),
                      isloadingGuset
                          ? CupertinoActivityIndicator(
                              animating: true,
                              color: AppColors.primaryColor,
                              radius: 20,
                            )
                          : CustomBtn(
                              btncolor: AppColors.backgroundColor,
                              textcolor: AppColors.primaryColor,
                              text: 'Guest',
                              ontap: loginGuset,
                            ),
                      Row(
                        children: [
                          CustomText(
                            text: 'Dont Have Account ?',
                            weight: FontWeight.w500,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          Gap(10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SingupView();
                                  },
                                ),
                              );
                            },
                            child: CustomText(
                              text: 'SingUp',
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
