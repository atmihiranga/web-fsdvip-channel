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
        if (widget.analysisResultLink != '')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Before')],
          ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.64,
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
        if (widget.analysisResultLink != '')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('After'),
              )
            ],
          ),
        if (widget.analysisResultLink != '')
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.64,
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
      ],
    );
  }
}
