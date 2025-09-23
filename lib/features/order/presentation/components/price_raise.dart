import '../../../../core/config/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../manager/order_cubit/cubit.dart';
import '../manager/order_cubit/state.dart';

class PriceRaise extends StatelessWidget {
  final double historicalAverage;
  final double marketMin;
  final double marketMax;

  const PriceRaise({
    super.key,
    required this.historicalAverage,
    required this.marketMin,
    required this.marketMax,
  });

  int _calculateDynamicStep(double currentPrice) {
    if (currentPrice < historicalAverage) return 5;
    if (currentPrice > historicalAverage * 1.1) return 10;
    return 7;
  }

  String _getPriceStatus(double currentPrice) {
    if (currentPrice < historicalAverage) return AppStrings.lowOffer;
    if (currentPrice > historicalAverage * 1.15) return AppStrings.premiumOffer;
    return AppStrings.fairOffer;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final cubit = context.read<OrderCubit>();
        final currentPrice = double.tryParse(state.orderModel?.price??"0") ?? historicalAverage;
        final basePrice = historicalAverage;

        void updatePrice(double newPrice) {
          final clampedPrice = newPrice.clamp(marketMin, marketMax);
          cubit.raisePrice(clampedPrice.toString());
        }

        return Column(
          spacing: 15.w,
          children: [
            Text(AppStrings.priceEdit, style: AppTextStyle.font14black500),
            _buildMarketInfo(basePrice),
            _buildPriceControls(currentPrice, updatePrice),
            _buildPriceStatus(currentPrice),
          ],
        );
      },
    );
  }

  Widget _buildMarketInfo(double basePrice) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.info_outline, size: 16.sp, color: AppColors.secondary),
      5.horizontalSpace,
      Text(
        '${AppStrings.suggestedPrice}: ${basePrice.toStringAsFixed(1)}-${marketMax.toStringAsFixed(1)}ر.س',
        style: AppTextStyle.font14black500.copyWith(color: AppColors.secondary),
      ),
    ],
  );

  Widget _buildPriceControls(double currentPrice, Function(double) updatePrice) => Row(
    spacing: 10.w,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.arrow_downward,
            color: currentPrice == marketMin ? Colors.grey : Colors.red),
        onPressed: currentPrice > marketMin
            ? () => updatePrice(currentPrice - _calculateDynamicStep(currentPrice))
            : null,
        iconSize: 25,
      ),
      RichText(
        text: TextSpan(
          text: '${currentPrice.toStringAsFixed(1)} ',
          style: AppTextStyle.font24secondary600,
          children: [
            TextSpan(
              text: 'ر.س',
              style: AppTextStyle.font18black600,
            ),
          ],
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_upward,
            color: currentPrice == marketMax ? Colors.grey : Colors.green),
        onPressed: currentPrice < marketMax
            ? () => updatePrice(currentPrice + _calculateDynamicStep(currentPrice))
            : null,
        iconSize: 25,
      ),
    ],
  );

  Widget _buildPriceStatus(double currentPrice) => Text(
    _getPriceStatus(currentPrice),
    style: TextStyle(
      color: currentPrice < historicalAverage ? Colors.red : Colors.green,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    ),
  );
}