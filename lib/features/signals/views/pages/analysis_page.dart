import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/analysis_chart_images.dart';

class AnalysisPage extends StatelessWidget {
  final String analysisLink;
  final String analysisResultLink;
  const AnalysisPage({
    super.key,
    required this.analysisLink,
    required this.analysisResultLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Chart'),
      ),
      body: Column(
        children: [
          Expanded(
              child: AnalysisChartImages(
            analysisLink: analysisLink,
            analysisResultLink: analysisResultLink,
          ))
        ],
      ),
    );
  }
}
