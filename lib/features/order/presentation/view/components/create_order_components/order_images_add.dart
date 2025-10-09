import 'dart:io';

import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/style/app_color.dart';
import '../../../../../../core/config/style/app_text_styles.dart';

class OrderImagesAdd extends StatelessWidget {
  final Function() onAddTap;
  final Function(File image) onImageRemoveTap;
  final List<File> images;
  const OrderImagesAdd({
    super.key,
    required this.onAddTap,
    required this.images,
    required this.onImageRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: LocaleKeys.enter_order_images.tr(),
            style: AppTextStyle.font16black500,
            children: [
              TextSpan(
                text: '   ${LocaleKeys.minimum_3_images_and_max_5_images.tr()}',
                style: AppTextStyle.font12desSelected600,
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            Container(
              width: 65.w,
              height: 65.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.desSelected, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: onAddTap,
                child: const Icon(Icons.add, size: 30),
              ),
            ),
            ...List.generate(
              images.length,
              (index) => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 65.w,
                    height: 65.w,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    foregroundDecoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.desSelected,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(images[index], fit: BoxFit.cover),
                  ),
                  IconButton(
                    onPressed: () {
                      onImageRemoveTap.call(images[index]);
                    },
                    icon: const Icon(Icons.remove_circle, color: AppColors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
