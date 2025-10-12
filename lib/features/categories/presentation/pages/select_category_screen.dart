import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../order/presentation/view_model/order_cubit/cubit.dart';
import '../manager/cubit.dart';
import '../manager/state.dart';
import '../widgets/category_item.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.categories.tr()),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen:
            (_, current) =>
                current is LoadingState ||
                current is SuccessState ||
                current is ErrorState,
        builder: (context, state) {
          if (state is LoadingState) {
            // make shimmer effect
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 140.w,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 16.w,
              ),
              itemBuilder: (context, index) => _buildShimmer(),
            );
          }
          if (state is ErrorState) {
            return const Center(child: Text(LocaleKeys.error));
          }
          if (state is SuccessState) {
            return RefreshIndicator(
              onRefresh: () async {
                return await context.read<CategoryCubit>().getCategories();
              },
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: state.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 140.w,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 16.w,
                ),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return GestureDetector(
                    onTap: () {
                      context.read<OrderCubit>().setCategory(
                        categoryModel: category,
                      );
                      if (category.isPerson) {
                        Navigator.pushNamed(context, AppRoutes.pickLocation);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.newOrder);
                      }
                    },
                    child: CategoryItem(categoryModel: category),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        spacing: 10.w,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Container(width: 85.w, height: 85.w, color: Colors.white),
          ),
          Container(
            width: 60.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
