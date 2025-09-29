import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/assets.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.assetsImagesSplashBack,
      width: size.w,
      height: size.w,
    );
  }
}
