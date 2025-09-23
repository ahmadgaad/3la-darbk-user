import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../../auth/presentation/widgets/name_field.dart';
import '../../../auth/presentation/widgets/phone_number_field.dart';
import '../manager/profile_cubit/cubit.dart';
import '../manager/profile_cubit/state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile2),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return LoadingOverlay(
            isLoading: state.loading,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      cubit.pickImage();
                    },
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        AppImageView(
                          shape: BoxShape.circle,
                          url: state.currentUser?.image ?? "no-image",
                          file: cubit.image,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                          foregroundDecoration: const BoxDecoration(
                              color: Colors.black26, shape: BoxShape.circle),
                        ),
                        const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                25.verticalSpaceFromWidth,
                Form(
                  key: cubit.formKey,
                  child: Column(
                    spacing: 10.h,
                    children: [
                      NameField(controller: cubit.nameController),
                      PhoneNumberField(controller: cubit.phoneController),
                    ],
                  ),
                ),
                20.verticalSpaceFromWidth,
                ElevatedButton(
                  onPressed:cubit.updateData,
                  child: const Text(AppStrings.confirm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
