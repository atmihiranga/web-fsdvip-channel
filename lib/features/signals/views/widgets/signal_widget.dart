import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_3_forex_signals_daily/features/signals/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SignalWidget extends StatelessWidget {
  final SignalModel signaldata;

  const SignalWidget({
    super.key,
    required this.signaldata,
  });

  String _formatDate(int timestamp) {
    if (timestamp == 0) return '-';
    return DateFormat('MMM dd HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  @override
  Widget build(BuildContext context) {
    final isVip = signaldata.isActive && !signaldata.isTp1Hit;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withAlpha(15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCell(_formatDate(signaldata.timestamp), 110),
          _buildCell(
            !signaldata.isActive
                ? _formatDate(signaldata.trackingTimestamp)
                : 'Active',
            110,
            color:
                signaldata.isActive ? AppColors.blue : AppColors.whiteDisabled,
          ),
          _buildSymbolCell(),
          _buildTelegramCell(),
          _buildCell(signaldata.entry.toString(), 80, bold: true),
          _buildTpSlCell(signaldata.tp1, signaldata.isTp1Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(signaldata.tp2, signaldata.isTp2Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(signaldata.tp3, signaldata.isTp3Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(signaldata.sl, signaldata.isSlHit, 100,
              isSL: true, isVip: isVip),
          _buildResultCell(),
        ],
      ),
    );
  }

  Widget _buildTelegramCell() {
    return SizedBox(
      width: 100,
      child: Row(
        spacing: 8,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () async {
                if (signaldata.freeChannelMessageID == 0) return;
                final url = Uri.parse(
                    'https://t.me/forexsignalsdailyapp/${signaldata.freeChannelMessageID}');
                if (await launchUrl(url)) {
                  // URL launched successfully
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blue.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Icon(
                    FontAwesomeIcons.telegram,
                    color: AppColors.blue,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () async {
                if (signaldata.freeChannelMessageID == 0) return;
                final url = Uri.parse(
                    'https://t.me/c/1966931051/${signaldata.vipChannelMessageID}');
                if (await launchUrl(url)) {
                  // URL launched successfully
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blue.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Icon(
                        FontAwesomeIcons.telegram,
                        color: AppColors.blue,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FaIcon(
                          FontAwesomeIcons.crown,
                          size: 6,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, double width,
      {Color? color, bool bold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? AppColors.white,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSymbolCell() {
    return SizedBox(
      width: 110,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: signaldata.action.toUpperCase() == 'BUY'
                  ? AppColors.green.withAlpha(30)
                  : AppColors.red.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              signaldata.action.toUpperCase() == 'BUY'
                  ? Icons.trending_up
                  : Icons.trending_down,
              size: 14,
              color: signaldata.action.toUpperCase() == 'BUY'
                  ? AppColors.green
                  : AppColors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            signaldata.symbol,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTpSlCell(double value, bool isHit, double width,
      {required bool isSL, bool isVip = false}) {
    return SizedBox(
      width: width,
      child: Row(
        spacing: 4,
        children: [
          if (isHit && !isVip) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSL
                    ? AppColors.red.withAlpha(30)
                    : AppColors.green.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSL ? Icons.close : Icons.check,
                size: 14,
                color: isSL ? AppColors.red : AppColors.green,
              ),
            ),
          ],
          if (!isHit || isVip) ...[
            SizedBox(
              width: 22,
            ),
          ],
          Text(
            isVip ? 'VIP' : '${value.toString()}',
            style: TextStyle(
              color: isVip ? AppColors.orange : AppColors.white.withAlpha(200),
              fontWeight: isVip ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCell() {
    final result = signaldata.pnlPips;
    final isProfit = result > 0;
    final isZero = result == 0;

    return SizedBox(
      width: 90,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isZero
              ? AppColors.blue.withAlpha(20)
              : isProfit
                  ? AppColors.green.withAlpha(20)
                  : AppColors.red.withAlpha(20),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${isProfit ? '+' : ''}${result.toStringAsFixed(1)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isZero
                ? AppColors.blue
                : isProfit
                    ? AppColors.green
                    : AppColors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
