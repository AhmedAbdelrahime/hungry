import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/home/data/models/proudect_model.dart';
import 'package:hungry/features/home/data/repos/proudect_repo.dart';
import 'package:hungry/features/proudect/view/proudect_view.dart';
import 'package:hungry/shared/category_items.dart';
import 'package:hungry/shared/custom_card_item.dart';
import 'package:hungry/shared/custom_snackbar.dart';
import 'package:hungry/shared/header.dart';
import 'package:hungry/shared/search_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CategoriesModel> cat = [];
  int selectedIndex = 0;
  ProudectRepo proudectRepo = ProudectRepo();
  List<ProudectModel>? proudects = [];
  bool isLoading = true;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();
  bool hasimage = false;
  bool isGuest = false;
  bool isLoadingProfile = true; // اللي بتتعرض دلوقتي
  List<ProudectModel>? allProudects = []; // نسخة كاملة للمقارنة

  Future<void> getProfileData() async {
    try {
      // أول حاجة نتأكد هل المستخدم Guest
      final token = await PrefHelpers.getToken();
      if (token == null || token == 'guest') {
        setState(() {
          isGuest = true;
          isLoadingProfile = false;
          userModel = null;
        });
        return; // Guest → ما نجيبش profile
      }
      final user = await authRepo.getProfileData();
      if (!mounted) return;

      setState(() {
        userModel = user;
        isGuest = false; //
        hasimage = user?.image?.isNotEmpty == true;

        isLoadingProfile = false;
      });
    } catch (e) {
      setState(() {
        isGuest = true; // 👈 لو فشل يبقى Guest
        isLoadingProfile = false;
      }); // 👈 لو فشل يبقى Guest

      // String errorMsg = 'Error in Get profile Data';
      // ScaffoldMessenger.of(context).showSnackBar(customSnakBar(errorMsg));
    }
  }

  Future<void> getProducts() async {
    final res = await proudectRepo.getProudects();
    setState(() {
      proudects = res;
      allProudects = res;
      isLoading = false;
    });
  }

  Future<void> getcategories() async {
    final res = await proudectRepo.getCategories();

    setState(() {
      cat = res;
    });
  }

  // داخل _HomeViewState
  // Future<void> searchProducts(String query) async {
  //   try {
  //     final results = await proudectRepo.searchProducts(query);
  //     if (!mounted) return;
  //     setState(() {
  //       proudects = results;
  //     });
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       customSnakBar('Failed to search products', color: Colors.red),
  //     );
  //   }
  // }
  void searchProductsLocally(String query) {
    if (query.isEmpty) {
      setState(() {
        proudects = allProudects;
      });
      return;
    }

    final results = allProudects
        ?.where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.desc.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    setState(() {
      proudects = results;
    });
  }

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once after this object
  /// is created. It should not be called from within this method
  /// nor from any other lifecycle methods.
  /// *****  64728787-182a-4612-8866-3706de0638ae  ******
  void initState() {
    getProfileData();
    getProducts();
    getcategories();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Skeletonizer(
        enabled: isLoading,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await getProfileData();

              ScaffoldMessenger.of(context).showSnackBar(
                customSnakBar('up date seccuss', color: Colors.green),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Column(
                children: [
                  Skeletonizer(
                    enabled: isLoadingProfile,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(name: userModel?.name ?? 'Guset'),
                        Spacer(),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            border: Border.all(width: 2, color: Colors.white60),
                          ),
                          child: ClipOval(
                            clipBehavior: Clip.antiAlias,

                            child: Image.network(
                              fit: BoxFit.cover,
                              userModel?.image ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                );
                              },
                            ),
                            // child: Image.asset('name'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SearchField(onChanged: searchProductsLocally),
                  Gap(20),
                  CategoryItems(selectedIndex: selectedIndex, cat: cat),
                  Gap(10),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: proudects?.length ?? 0,
                      itemBuilder: (context, index) {
                        final proudect = proudects?[index];

                        return GestureDetector(
                          onTap: () {
                            if (isLoadingProfile) {
                              return; // لسه بنحمل الداتا
                            }
                            if (isGuest) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnakBar(
                                  'Please login first',
                                  color: Colors.red,
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProudectView(
                                    imageurl: proudect?.image ?? '',
                                    name: proudect?.name ?? '',
                                    desc: proudect?.desc ?? '',
                                    id: proudect?.id ?? 0,
                                    price: proudect?.price ?? '',
                                  );
                                },
                              ),
                            );
                          },
                          child: CustomCardItem(
                            img: proudect?.image ?? '',
                            text: proudect?.name ?? '',
                            des: proudect?.desc ?? '',
                            rate: proudect?.rate ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
