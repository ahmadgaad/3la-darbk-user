import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/style/app_color.dart';
import '../../../core/config/style/app_text_styles.dart';
import '../../profile/presentation/manager/profile_cubit/cubit.dart';
import '../../profile/presentation/manager/profile_cubit/state.dart';

class CustonDrawerHeader extends StatelessWidget {
  const CustonDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.w,
      child: DrawerHeader(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        decoration: const BoxDecoration(color: AppColors.primary),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final user = state.currentUser;
            return Row(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.scaleDown,
                    imageUrl: user?.image ?? "",
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.w,
                    children: [
                      Text(
                        user?.name ?? "user name",
                        style: AppTextStyle.font16white600,
                      ),
                      Text(
                        user?.mobile ?? "+966",
                        style: AppTextStyle.font14white600,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
