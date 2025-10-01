import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';

class OrderSizeSelect extends StatefulWidget {
  ///[selectedSize] 0 small 1 medium 2 large
  final Function(int selectedSize) onSizeTap;

  final int selectedSize;
  const OrderSizeSelect({
    super.key,
    required this.onSizeTap,
    required this.selectedSize,
  });

  @override
  State<OrderSizeSelect> createState() => _OrderSizeSelectState();
}

class _OrderSizeSelectState extends State<OrderSizeSelect> {
  final List<String> sizes = [
    AppStrings.small,
    AppStrings.medium,
    AppStrings.larage,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.h,
      children: [
        Text(AppStrings.orderSize, style: AppTextStyle.font16black500),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            sizes.length,
            (index) => _selectableButton(
              () {
                widget.onSizeTap.call(index);
              },
              sizes[index],
              widget.selectedSize == index,
            ),
          ),
        ),
        Text(
          AppStrings.smallOrdersBetween,
          style: AppTextStyle.font12desSelected600,
        ),
      ],
    );
  }

  Widget _selectableButton(
    VoidCallback onPressed,
    String text,
    bool isSelected,
  ) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
      fixedSize: Size.fromHeight(40.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : AppColors.primary,
        ),
      ),
    ),
    child: Text(
      text,
      style:
          isSelected
              ? AppTextStyle.font16white500
              : AppTextStyle.font16black500,
    ),
  );
}
