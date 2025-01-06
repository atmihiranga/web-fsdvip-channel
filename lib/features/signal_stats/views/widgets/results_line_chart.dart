import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/models/data_points.dart';
import 'dart:math' as math;

class ResultsLineChart extends StatefulWidget {
  final List<DataPoint> dataPoints;

  const ResultsLineChart({super.key, required this.dataPoints});

  @override
  State<ResultsLineChart> createState() => _ResultsLineChartState();
}

class _ResultsLineChartState extends State<ResultsLineChart> {
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

    // Filter the data points based on the current slider range
    final filteredDataPoints = widget.dataPoints.where((point) {
      final xValue = point.timestamp.toDouble();
      return xValue >= _currentStart && xValue <= _currentEnd;
    }).toList();

    // If for some reason the filter returns no points, fall back to entire dataPoints
    final pointsForY =
        filteredDataPoints.isNotEmpty ? filteredDataPoints : widget.dataPoints;

    // Compute the minY and maxY from the filtered points
    final minY = pointsForY.map((p) => p.result.toDouble()).reduce(math.min);
    final maxY = pointsForY.map((p) => p.result.toDouble()).reduce(math.max);

    // Create the chart spots from all data (so the chart lines remain continuous)
    // or from filtered data if you only want to display the visible points.
    final chartSpots = widget.dataPoints
        .map((point) => FlSpot(
              point.timestamp.toDouble(),
              point.result.toDouble(),
            ))
        .toList();

    // We want 5 labels => 4 intervals between them.
    final double interval = (_currentEnd - _currentStart) / 5;

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
                  'Cumulative Pips (${formatTimestamp(_currentStart.toInt(), showYear: true, showTime: false)} - ${formatTimestamp(_currentEnd.toInt(), showYear: true, showTime: false)})')),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                clipData: FlClipData.all(),
                // Use the range slider values for minX and maxX
                minX: _currentStart,
                maxX: _currentEnd,

                // Apply the dynamic minY and maxY
                minY: minY,
                maxY: maxY,

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
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${date.year.toString().substring(2)}/${date.month}/${date.day}',
                            style: const TextStyle(fontSize: 12),
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
                    spots: chartSpots,
                    isCurved: true,
                    color: AppColors.green,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipColor: (touchedSpot) {
                      return AppColors.background.withAlpha(50);
                    },
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map(
                        (LineBarSpot touchedSpot) {
                          final dateString = formatTimestamp(
                            touchedSpot.x.toInt(),
                            showYear: true,
                          );
                          final text =
                              '${touchedSpot.y.toStringAsFixed(2)} Pips\n$dateString';
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
