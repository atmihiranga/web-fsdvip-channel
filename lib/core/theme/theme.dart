import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.orange,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      color: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.orange,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        backgroundColor: WidgetStateProperty.all(AppColors.darkOpacity1),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 20,
          ),
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
  );
}
