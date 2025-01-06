import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import '../../models/data_points.dart';

class BarChartWidget extends StatefulWidget {
  final List<DataPoint> dataPoints;

  const BarChartWidget({super.key, required this.dataPoints});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late double _currentStart;
  late double _currentEnd;

  @override
  void initState() {
    super.initState();
    // In this example, we're assuming dataPoints is not empty
    _currentStart = widget.dataPoints.first.timestamp.toDouble();
    _currentEnd = widget.dataPoints.last.timestamp.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final minTimestamp = widget.dataPoints.first.timestamp.toDouble();
    final maxTimestamp = widget.dataPoints.last.timestamp.toDouble();
    // We want 5 labels => 4 intervals between them.
    final double interval = (_currentEnd - _currentStart) / 5;

    final barGroups = widget.dataPoints.map((data) {
      final isNegative = data.result < 0;
      return BarChartGroupData(
        x: data.timestamp,
        barRods: [
          BarChartRodData(
            toY: data.result,
            color: isNegative ? AppColors.red : AppColors.green,
            width: 1,
          ),
        ],
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.backgroundDarker2,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        spacing: 20,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Individual PnL (${formatTimestamp(_currentStart.toInt(), showYear: true, showTime: false)} - ${formatTimestamp(_currentEnd.toInt(), showYear: true, showTime: false)})')),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                barGroups: barGroups
                    .where((group) =>
                        group.x >= _currentStart && group.x <= _currentEnd)
                    .toList(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipColor: (touchedSpot) {
                      return AppColors.background.withAlpha(50);
                    },
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(1)}\n${formatTimestamp(group.x.toInt())}',
                          TextStyle());
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      maxIncluded: false,
                      minIncluded: false,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                          value.toInt(),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${date.year.toString().substring(2)}/${date.month}/${date.day}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.amberAccent),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      maxIncluded: false,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      strokeWidth: 0.1,
                    );
                  },
                  drawHorizontalLine: false,
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              // trackHeight: 36,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: RangeSlider(
              min: minTimestamp,
              max: maxTimestamp,
              values: RangeValues(_currentStart, _currentEnd),
              onChanged: (values) {
                setState(() {
                  _currentStart = values.start;
                  _currentEnd = values.end;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
