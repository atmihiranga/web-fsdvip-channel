import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Chart extends StatefulWidget {
  final String symbol;
  const Chart({super.key, required this.symbol});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
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
            url: WebUri(
                'https://www.tradingview.com/chart/?symbol=${widget.symbol}'),
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
      ],
    );
  }
}
