import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class CustomBarChart extends StatefulWidget {
  final Map<String, dynamic> data;

  /// A widget that takes [data] where the key is a string epoch timestamp
  /// (e.g. "1672531200000") and the value is a numeric value stored as dynamic.
  const CustomBarChart({
    super.key,
    required this.data,
  });

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late RangeValues _currentRangeValues;
  late double _minX;
  late double _maxX;
  late Map<int, double> _convertedData;
  late List<int> _sortedKeys;
  final int _numberOfTitles = 5;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Convert string epochs to int and values to double
    _convertedData = {};
    widget.data.forEach((key, value) {
      final epoch = int.tryParse(key);
      if (epoch != null && value is num) {
        _convertedData[epoch] = value.toDouble();
      }
    });

    // Sort timestamps
    _sortedKeys = _convertedData.keys.toList()..sort();

    // Initialize range values
    _minX = _sortedKeys.first.toDouble();
    _maxX = _sortedKeys.last.toDouble();
    _currentRangeValues = RangeValues(_minX, _maxX);
  }

  List<BarChartGroupData> _getFilteredBarGroups() {
    return _sortedKeys
        .where((timestamp) =>
            timestamp >= _currentRangeValues.start &&
            timestamp <= _currentRangeValues.end)
        .map((timestamp) {
      final value = _convertedData[timestamp] ?? 0;

      return BarChartGroupData(
        x: timestamp,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value > 0 ? AppColors.green : Colors.red,
            width: 1,
          )
        ],
      );
    }).toList();
  }

  bool _shouldShowTitle(double value) {
    final range = _currentRangeValues.end - _currentRangeValues.start;
    final interval = range / (_numberOfTitles - 1);

    for (int i = 0; i < _numberOfTitles; i++) {
      final targetValue = _currentRangeValues.start + (interval * i);
      if ((value - targetValue).abs() < 0.0001) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final barGroups = _getFilteredBarGroups();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarker2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 20,
        children: [
          Text('• Individiual Signal PnL Pips Graph'),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                // minX: _currentRangeValues.start,
                // maxX: _currentRangeValues.end,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (!_shouldShowTitle(value)) {
                          return const SizedBox.shrink();
                        }

                        final date = DateTime.fromMillisecondsSinceEpoch(
                          value.toInt(),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM-dd').format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
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
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    direction: TooltipDirection.top,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipColor: (touchedSpot) {
                      return AppColors.background.withAlpha(100);
                    },
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(0)} Pips\n${formatTimestamp(group.x.toInt())}',
                        TextStyle(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Range Slider
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                RangeSlider(
                  values: _currentRangeValues,
                  min: _minX,
                  max: _maxX,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.green.withAlpha(120),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTimestamp(_currentRangeValues.start.toInt(),
                            showYear: true, showTime: false),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        formatTimestamp(_currentRangeValues.end.toInt(),
                            showYear: true, showTime: false),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
