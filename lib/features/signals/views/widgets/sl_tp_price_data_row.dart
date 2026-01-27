import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_3_forex_signals_daily/core/helpers/show_snackbar.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class SlTpPriceRow extends StatelessWidget {
  const SlTpPriceRow({
    super.key,
    required this.priceLabel,
    required this.price,
    required this.isLocked,
    required this.isHit,
  });

  final String priceLabel;
  final String price;
  final bool isLocked;
  final bool isHit;

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
                child: Text(priceLabel),
              )),
              Expanded(child: Text(price)),
              isLocked
                  ? Row(
                      children: [
                        Icon(Icons.lock_open,
                            size: 12.0, color: AppColors.orange),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Unlock',
                          style: TextStyle(color: AppColors.orange),
                        ),
                      ],
                    )
                  : Icon(
                      isHit
                          ? priceLabel == 'Stop Loss'
                              ? Icons.close
                              : Icons.done
                          : Icons.copy,
                      size: 12.0,
                      color: isHit
                          ? priceLabel == 'Stop Loss'
                              ? AppColors.red
                              : AppColors.green
                          : AppColors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
