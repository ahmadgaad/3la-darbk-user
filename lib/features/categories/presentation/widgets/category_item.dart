import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/widgets/app_image_view.dart';
import '../../repositories/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel? categoryModel;
  const CategoryItem({super.key, this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.w,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: AppImageView(
            url: categoryModel?.image ?? "asd",
            width: 85.w,
            height: 85.w,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          categoryModel?.name ?? "",
          maxLines: 1,
          textAlign: TextAlign.center,
          style: AppTextStyle.font16black500,
        ),
      ],
    );
  }
}
