import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class CustomLineChart extends StatefulWidget {
  final Map<String, dynamic> data;

  const CustomLineChart({super.key, required this.data});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  late RangeValues _currentRangeValues;
  late double _minX;
  late double _maxX;
  late List<MapEntry<int, double>> _entries;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Convert and sort data
    _entries = widget.data.entries.map((e) {
      final epoch = int.tryParse(e.key) ?? 0;
      final value = (e.value as num).toDouble();
      return MapEntry(epoch, value);
    }).toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Initialize range values
    _minX = _entries.first.key.toDouble();
    _maxX = _entries.last.key.toDouble();
    _currentRangeValues = RangeValues(_minX, _maxX);
  }

  List<FlSpot> _getFilteredSpots() {
    // Filter entries based on current range
    final filteredEntries = _entries
        .where((entry) =>
            entry.key >= _currentRangeValues.start &&
            entry.key <= _currentRangeValues.end)
        .toList();

    // Calculate cumulative sum for filtered entries
    double cumulative = 0;
    return filteredEntries.map((entry) {
      cumulative += entry.value;
      return FlSpot(entry.key.toDouble(), cumulative);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getFilteredSpots();
    final double interval =
        (_currentRangeValues.end - _currentRangeValues.start) / 5;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarker2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 20,
        children: [
          Text('• Cumulative Pips Graph'),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                minX: _currentRangeValues.start,
                maxX: _currentRangeValues.end,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  //verticalInterval: 5,
                  getDrawingVerticalLine: (value) {
                    return FlLine(strokeWidth: 0.1, color: AppColors.white);
                  },
                  drawHorizontalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      maxIncluded: false,
                      minIncluded: false,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                          value.toInt(),
                        );
                        return SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.month}/${date.day}\n${date.year.toString()}',
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                      reservedSize: 45,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      maxIncluded: false,
                      minIncluded: false,
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
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.green,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    showOnTopOfTheChartBoxArea: true,
                    getTooltipColor: (touchedSpot) {
                      return AppColors.background.withAlpha(100);
                    },
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map(
                        (LineBarSpot touchedSpot) {
                          final dateString = formatTimestamp(
                            touchedSpot.x.toInt(),
                            showYear: true,
                          );
                          final text =
                              '${touchedSpot.y.toStringAsFixed(0)} Pips\n$dateString';
                          return LineTooltipItem(
                            text,
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ).toList();
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
                  inactiveColor: AppColors.green.withAlpha(80),
                ),
                // Date labels for slider
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
