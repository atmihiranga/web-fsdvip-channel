import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/analysis_webview.dart';

class AnalysisPage extends StatelessWidget {
  final String analysisLink;
  const AnalysisPage({super.key, required this.analysisLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: Column(
        children: [
          Expanded(
              child: AnalysisWebview(
            analysisLink: analysisLink,
          ))
        ],
      ),
    );
  }
}
