import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';
import 'app_text_styles.dart';

ThemeData get appTheme => ThemeData(
    useMaterial3: true,
    fontFamily: "cairo",
    appBarTheme: AppBarTheme(
        titleTextStyle: AppTextStyle.font16black600,
        titleSpacing: 0,
        actionsIconTheme: const IconThemeData(color: AppColors.primary),
        // iconTheme: IconThemeData(color: AppColor.primary),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: AppColors.white,
            statusBarIconBrightness: Brightness.dark)),
    dividerColor: AppColors.desSelected,
    dividerTheme: const DividerThemeData(color: AppColors.desSelected),
    cardTheme: CardThemeData(
      color: AppColors.lightGrey,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.lightBlack,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: AppTextStyle.font16primary600,
      unselectedLabelStyle: AppTextStyle.font16desSelected500,
    ),
    scaffoldBackgroundColor: AppColors.backGround,
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: AppTextStyle.font16white500,
          foregroundColor: AppColors.white,
          fixedSize: Size.fromHeight(55.w),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.primary,
      hintStyle: AppTextStyle.font16desSelected500,
      suffixIconColor: AppColors.secondary,
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary)),
      contentPadding: EdgeInsets.only(top: 10.h),
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    ),
    colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backGround));

ThemeData get homeTheme => ThemeData(
    useMaterial3: true,
    fontFamily: "cairo",
    iconTheme: const IconThemeData(color: AppColors.secondary),
    listTileTheme: ListTileThemeData(
        iconColor: AppColors.secondary,
        titleTextStyle: AppTextStyle.font16black500),
    drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(), backgroundColor: AppColors.backGround),
    appBarTheme: AppBarTheme(
        titleTextStyle: AppTextStyle.font16black600,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: AppColors.white,
            statusBarIconBrightness: Brightness.dark)),
    tabBarTheme: TabBarThemeData(
      dividerColor: AppColors.desSelected,
      dividerHeight: 1,
      indicatorSize: TabBarIndicatorSize.tab,
      
      indicator: const BoxDecoration(
        color: AppColors.primary,
      ),
      labelStyle: AppTextStyle.font16white600,
      unselectedLabelStyle: AppTextStyle.font16black600,
    ),
    scaffoldBackgroundColor: AppColors.backGround,
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: AppTextStyle.font16white500,
          foregroundColor: AppColors.white,
          fixedSize: Size.fromHeight(55.w),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.secondary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.primary),
      textStyle: AppTextStyle.font14black600,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      extendedTextStyle: AppTextStyle.font16white600,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.primary,
      hintStyle: AppTextStyle.font16desSelected500,
      suffixIconColor: AppColors.secondary,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary)),
      contentPadding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    ),
    colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backGround));
