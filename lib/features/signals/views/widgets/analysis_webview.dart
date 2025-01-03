import 'package:flutter/material.dart';

class AnalysisWebview extends StatefulWidget {
  final String analysisLink;
  final String analysisResultLink;
  const AnalysisWebview({
    super.key,
    required this.analysisLink,
    required this.analysisResultLink,
  });

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
        // Column(
        //   children: [
        //     Expanded(
        //       child: SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         child: InAppWebView(
        //           initialUrlRequest: URLRequest(
        //             url: WebUri(widget.analysisLink),
        //           ),
        //           onLoadStart: (controller, url) {
        //             setState(() {
        //               isLoading = true;
        //             });
        //           },
        //           onLoadStop: (controller, url) {
        //             setState(() {
        //               isLoading = false;
        //             });
        //           },
        //         ),
        //       ),
        //     ),
        //     if (widget.analysisResultLink != '')
        //       Expanded(
        //         child: SizedBox(
        //           width: MediaQuery.of(context).size.width,
        //           child: InAppWebView(
        //             initialUrlRequest: URLRequest(
        //               url: WebUri(widget.analysisResultLink),
        //             ),
        //             onLoadStart: (controller, url) {
        //               setState(() {
        //                 isLoading = true;
        //               });
        //             },
        //             onLoadStop: (controller, url) {
        //               setState(() {
        //                 isLoading = false;
        //               });
        //             },
        //           ),
        //         ),
        //       )
        //   ],
        // ),

        // if (isLoading)
        //   const Center(
        //     child: CircularProgressIndicator(),
        //   ),

        Column(
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
        ),
      ],
    );
  }
}
