import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AnalysisWebview extends StatefulWidget {
  final String analysisLink;
  const AnalysisWebview({super.key, required this.analysisLink});

  @override
  State<AnalysisWebview> createState() => _AnalysisWebviewState();
}

class _AnalysisWebviewState extends State<AnalysisWebview> {
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.analysisLink),
          ),
          onLoadStart: (controller, url) {
            setState(() {
              isLoading = true;
            });
          },
          onLoadStop: (controller, url) {
            setState(() {
              isLoading = false;
            });
          },
        ),

        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),

        // $ shows the chart as a zoomable image instead of webview, might need in future
        // InteractiveViewer(
        //   minScale: 0.5,
        //   maxScale: 3,
        //   child: Image.network(
        //     widget.analysisLink,
        //     loadingBuilder: (context, child, loadingProgress) {
        //       if (loadingProgress == null) {
        //         return child;
        //       }
        //       return Center(
        //         child: SizedBox(
        //           child: CircularProgressIndicator(),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
