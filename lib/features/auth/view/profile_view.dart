import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/widgets/textfieled_auth.dart';
import 'package:hungry/shared/custom_btn.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _namecontroler = TextEditingController();
  final TextEditingController _emailcontroler = TextEditingController();
  final TextEditingController _visadcontroler = TextEditingController();
  final TextEditingController _addresscontroler = TextEditingController();
  String? selectedImage;
  AuthRepo authRepo = AuthRepo();
  bool isloading = false;
  bool isloadinglogout = false;
  bool isGuest = false;

  UserModel? userModel;
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = 'Error in profile';
      // ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
    }
  }

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

  Future<void> upadateProfileData() async {
    try {
      setState(() => isloading = true);

      final user = await authRepo.updateProfileData(
        name: _namecontroler.text.trim(),
        email: _emailcontroler.text.trim(),
        address: _addresscontroler.text.trim(),
        visa: _visadcontroler.text.trim(),
        imagepath: selectedImage,
      );
      setState(() {
        userModel = user;
      });
      await getProfileData();
      setState(() => isloading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        customSnakBar('Profile updated successfully', color: Colors.green),
      );
    } catch (e) {
      String errMsg = 'Filedeld to update profile';
      if (e is ApiError) errMsg = e.message;

      ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errMsg));
    }
  }

  Future<void> pickimage() async {
    final pickedImaged = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedImaged != null) {
        setState(() {
          selectedImage = pickedImaged.path;
        });
      }
    });
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

  Future<void> _initProfile() async {
    await autologin();
    await getProfileData();

    _namecontroler.text = userModel?.name ?? '';
    _emailcontroler.text = userModel?.email ?? '';
    _visadcontroler.text = userModel?.visa ?? '';
    _addresscontroler.text = userModel?.address ?? '';
  }

  @override
  void initState() {
    _initProfile();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroler.dispose();
    _namecontroler.dispose();
    _visadcontroler.dispose();
    _addresscontroler.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isGuest
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: AppColors.primaryColor,
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                toolbarHeight: 40,
                scrolledUnderElevation: 0,
                actionsPadding: EdgeInsets.only(right: 20, top: 10),
                actions: [Icon(Icons.settings, size: 30, color: Colors.white)],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await getProfileData();

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(customSnakBar('up date seccuss'));
                },
                child: SingleChildScrollView(
                  child: Skeletonizer(
                    enabled: userModel == null,
                    enableSwitchAnimation: true,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 125,
                            width: 125,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(
                                width: 5,
                                color: Colors.white60,
                              ),
                            ),
                            child: ClipOval(
                              child: selectedImage != null
                                  ? Image.file(
                                      File(selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : (userModel?.image != null &&
                                        userModel!.image!.isNotEmpty)
                                  ? Image.network(
                                      userModel!.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_aspect_ratio_sharp,
                                                size: 50,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    ),
                            ),
                          ),
                        ),
                        Gap(10),
                        CustomBtn(
                          text: 'Upload Image',
                          widthBtn: 120,
                          widthText: 15,
                          hightBtn: 40,
                          ontap: pickimage,
                        ),
                        Gap(10),
                        TextfieledAuth(
                          controller: _namecontroler,
                          labelText: 'Name',
                        ),
                        TextfieledAuth(
                          controller: _emailcontroler,
                          labelText: 'Email',
                        ),

                        TextfieledAuth(
                          controller: _addresscontroler,
                          labelText: 'Address',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Divider(),
                        ),

                        // CreditCardWidget(
                        //   cardNumber: '',
                        //   expiryDate: '',
                        //   cardHolderName: '',
                        //   cvvCode: '',
                        //   showBackView: false,
                        //   onCreditCardWidgetChange: (CreditCardBrand p1) {},
                        // ),
                        userModel?.visa?.isNotEmpty == false
                            ? TextfieledAuth(
                                keyboardType: TextInputType.number,
                                controller: _visadcontroler,
                                labelText: ' **** **** **** **** ',
                                isPassowed: true,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: 'Debit Card',
                                              size: 14,
                                              weight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            CustomText(
                                              text: _visadcontroler.text,
                                              size: 14,
                                              weight: FontWeight.w300,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        CustomText(
                                          text: 'Defult',
                                          color: Colors.black,
                                        ),
                                        Gap(10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Gap(300),
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                height: 80,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.,
                  // color: AppColors.primaryColor,
                ),
                child: Row(
                  children: [
                    isloading
                        ? Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.primaryColor,
                              radius: 15,
                            ),
                          )
                        : GestureDetector(
                            onTap: upadateProfileData,
                            child: Container(
                              height: 60,
                              width: 150,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 3,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Edit Profile ',
                                    color: AppColors.primaryColor,
                                    weight: FontWeight.w600,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Spacer(),
                    isloadinglogout
                        ? Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.primaryColor,
                              radius: 15,
                            ),
                          )
                        : GestureDetector(
                            onTap: logout,
                            child: Container(
                              height: 60,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Logout ',
                                    color: AppColors.backgroundColor,
                                    weight: FontWeight.w600,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.logout_outlined,
                                    color: AppColors.backgroundColor,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )
        : Center(child: Text('Guset mode'));
  }
}
