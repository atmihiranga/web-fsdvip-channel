import 'package:flutter/material.dart';

class AnalysisChartImages extends StatefulWidget {
  final String analysisLink;
  final String analysisResultLink;
  const AnalysisChartImages({
    super.key,
    required this.analysisLink,
    required this.analysisResultLink,
  });

  @override
  State<AnalysisChartImages> createState() => _AnalysisChartImagesState();
}

class _AnalysisChartImagesState extends State<AnalysisChartImages> {
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.network(
                widget.analysisLink,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.analysisResultLink != '')
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.network(
                  widget.analysisResultLink,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
