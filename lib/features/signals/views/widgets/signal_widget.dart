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

  String _calculatePips(double value) {
    final pips = (signaldata.entry - value).abs() * signaldata.pipScale;
    return pips.toStringAsFixed(0);
  }

  // Calculate position results string
  String _calculatePositionResults() {
    // If SL is hit, show 3x loss
    if (signaldata.isSlHit) {
      final slPips =
          ((signaldata.entry - signaldata.sl).abs() * signaldata.pipScale);
      return '3 x -${slPips.toStringAsFixed(0)} Pips';
    }

    // Calculate TP pips for each level
    List<String> tpPips = [];

    if (signaldata.isTp1Hit) {
      final tp1Pips =
          ((signaldata.tp1 - signaldata.entry).abs() * signaldata.pipScale);
      tpPips.add(tp1Pips.toStringAsFixed(0));
    }

    if (signaldata.isTp2Hit) {
      final tp2Pips =
          ((signaldata.tp2 - signaldata.entry).abs() * signaldata.pipScale);
      tpPips.add(tp2Pips.toStringAsFixed(0));
    }

    if (signaldata.isTp3Hit) {
      final tp3Pips =
          ((signaldata.tp3 - signaldata.entry).abs() * signaldata.pipScale);
      tpPips.add(tp3Pips.toStringAsFixed(0));
    }

    if (tpPips.isEmpty) {
      return '-';
    }

    return '${tpPips.join(' + ')} Pips';
  }

  // Calculate actual PnL value
  double _calculatePnL() {
    // If SL is hit, return 3x loss
    if (signaldata.isSlHit) {
      final slPips =
          ((signaldata.entry - signaldata.sl).abs() * signaldata.pipScale);
      return -slPips * 3;
    }

    // Sum up all TP pips
    double totalPips = 0;

    if (signaldata.isTp1Hit) {
      final tp1Pips =
          ((signaldata.tp1 - signaldata.entry).abs() * signaldata.pipScale);
      totalPips += tp1Pips;
    }

    if (signaldata.isTp2Hit) {
      final tp2Pips =
          ((signaldata.tp2 - signaldata.entry).abs() * signaldata.pipScale);
      totalPips += tp2Pips;
    }

    if (signaldata.isTp3Hit) {
      final tp3Pips =
          ((signaldata.tp3 - signaldata.entry).abs() * signaldata.pipScale);
      totalPips += tp3Pips;
    }

    return totalPips;
  }

  @override
  Widget build(BuildContext context) {
    final isVip = signaldata.isActive && !signaldata.isTp1Hit;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCell(context, _formatDate(signaldata.timestamp), 110,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180)),
          _buildCell(
            context,
            !signaldata.isActive
                ? _formatDate(signaldata.trackingTimestamp)
                : 'Active',
            110,
            color: signaldata.isActive
                ? AppColors.accent
                : Theme.of(context).colorScheme.onSurface.withAlpha(150),
            bold: signaldata.isActive,
          ),
          _buildSymbolCell(context),
          _buildTelegramCell(),
          _buildCell(context, signaldata.entry.toString(), 80,
              bold: true, color: Theme.of(context).colorScheme.onSurface),
          _buildTpSlCell(context, signaldata.tp1, signaldata.isTp1Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(context, signaldata.tp2, signaldata.isTp2Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(context, signaldata.tp3, signaldata.isTp3Hit, 100,
              isSL: false, isVip: isVip),
          _buildTpSlCell(context, signaldata.sl, signaldata.isSlHit, 100,
              isSL: true, isVip: isVip),
          _buildPositionResultsCell(context),
          _buildPnLCell(),
        ],
      ),
    );
  }

  Widget _buildTelegramCell() {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            onTap: () async {
              if (signaldata.freeChannelMessageID == 0) return;
              final url = Uri.parse(
                  'https://t.me/forexsignalsdailyapp/${signaldata.freeChannelMessageID}');
              if (await launchUrl(url)) {}
            },
            icon: FontAwesomeIcons.telegram,
            color: AppColors.blue,
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            onTap: () async {
              if (signaldata.vipChannelMessageID == 0) return;
              final url = Uri.parse(
                  'https://t.me/c/1966931051/${signaldata.vipChannelMessageID}');
              if (await launchUrl(url)) {}
            },
            icon: FontAwesomeIcons.telegram,
            color: AppColors.accent,
            isVip: true,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required VoidCallback onTap,
      required FaIconData icon,
      required Color color,
      bool isVip = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40), width: 1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FaIcon(icon, color: color, size: 18),
            if (isVip)
              Positioned(
                top: -4,
                right: -4,
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  size: 8,
                  color: AppColors.orange,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, String text, double width,
      {Color? color, bool bold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSymbolCell(BuildContext context) {
    final isBuy = signaldata.action.toUpperCase() == 'BUY';
    return SizedBox(
      width: 110,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (isBuy ? AppColors.green : AppColors.red).withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isBuy ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: isBuy ? AppColors.green : AppColors.red,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            signaldata.symbol,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTpSlCell(
      BuildContext context, double value, bool isHit, double width,
      {required bool isSL, bool isVip = false}) {
    final color = isSL ? AppColors.red : AppColors.green;
    return SizedBox(
      width: width,
      child: Row(
        children: [
          if (isHit && !isVip) ...[
            Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSL ? Icons.close : Icons.check,
                size: 12,
                color: color,
              ),
            ),
          ] else ...[
            const SizedBox(width: 20),
          ],
          Text(
            isVip ? 'VIP' : value.toString(),
            style: TextStyle(
              color: isVip
                  ? AppColors.orange
                  : (isHit
                      ? color
                      : Theme.of(context).colorScheme.onSurface.withAlpha(150)),
              fontWeight: (isHit || isVip) ? FontWeight.bold : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionResultsCell(BuildContext context) {
    final positionResults = _calculatePositionResults();
    final isLoss = signaldata.isSlHit;
    final hasResults = positionResults != '-';

    return SizedBox(
      width: 150,
      child: Text(
        positionResults,
        style: TextStyle(
          color: !hasResults
              ? Theme.of(context).colorScheme.onSurface.withAlpha(150)
              : isLoss
                  ? AppColors.red
                  : AppColors.green,
          fontWeight: hasResults ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPnLCell() {
    final pnl = _calculatePnL();
    final isProfit = pnl > 0;
    final isZero = pnl == 0;
    final color = isZero
        ? AppColors.accent
        : isProfit
            ? AppColors.green
            : AppColors.red;

    return SizedBox(
      width: 90,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40), width: 1),
        ),
        child: Text(
          '${isProfit ? '+' : ''}${pnl.toStringAsFixed(1)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
