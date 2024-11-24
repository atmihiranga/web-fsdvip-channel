import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class SlTpPriceRow extends StatelessWidget {
  const SlTpPriceRow({
    super.key,
    required this.label,
    required this.price,
  });

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: AppColors.backgroundDarker,
      child: InkWell(
        // hoverColor: AppColors.orange,
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(label),
              )),
              Expanded(child: Text(price)),
              const Icon(
                Icons.copy,
                size: 12.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
