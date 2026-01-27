import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundDarker2,
      highlightColor: AppColors.backgroundLighter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.white.withAlpha(10),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildBlock(110),
            _buildBlock(110),
            _buildBlock(110),
            _buildBlock(100),
            _buildBlock(80),
            _buildBlock(80),
            _buildBlock(80),
            _buildBlock(80),
            _buildBlock(80),
            _buildBlock(90),
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(double width) {
    return Container(
      width: width * 0.7,
      height: 12,
      margin: EdgeInsets.only(right: width * 0.3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
