import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../order/presentation/manager/order_cubit/cubit.dart';
import '../manager/cubit.dart';
import '../manager/state.dart';
import '../widgets/category_item.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categries),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ErrorState) {
            return const Center(child: Text(AppStrings.error));
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
                itemBuilder:
                    (context, index) => GestureDetector(
                      onTap: () {
                        context.read<OrderCubit>().setCategory(
                          categoryModel: state.categories[index],
                        );
                        if(state.categories[index].isPerson??false){
                             Navigator.pushNamed(context, AppRoute.pickLocation);
                        }else {
                          Navigator.pushNamed(
                          context,
                          AppRoute.newOrder,
                        );
                        }
                      },
                      child: CategoryItem(
                        categoryModel: state.categories[index],
                      ),
                    ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
