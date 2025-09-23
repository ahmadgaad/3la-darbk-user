import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_image_view.dart';

class OrderImages extends StatelessWidget {
  final List<String> images;
  const OrderImages(
      {super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
               AppStrings.orderImages,
              style: AppTextStyle.font14black600),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
                images.length,
                (index) => AppImageView(
                    url: images[index],
                    onTap: ()async{
                      final url=images[index];  
                      if (await launchUrl(Uri.parse(url))) {
                        return;
                      }
                    },
                    border: Border.all(color: AppColors.desSelected, width: 1),
                    radius: BorderRadius.circular(8),
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.cover,
                  )),
        )
      ],
    );
  }
}
