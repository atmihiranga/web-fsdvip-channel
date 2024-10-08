import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class PremiumSLTPRow extends StatelessWidget {
  const PremiumSLTPRow({
    super.key,
    required this.label,
    required this.price,
  });

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarker,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(label),
            )),
            Expanded(child: Text(price)),
            Material(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.darkOpacity1,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Copy',
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
