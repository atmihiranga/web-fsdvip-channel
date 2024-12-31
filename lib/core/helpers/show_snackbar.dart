import 'package:flutter/material.dart';

void showSnackBarMessage({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
  Color backgroundColor = Colors.white,
  Color textColor = Colors.black,
  double elevation = 0.0,
  EdgeInsetsGeometry margin =
      const EdgeInsets.only(left: 16.0, right: 16, bottom: 96),
  BorderRadius? borderRadius,
  SnackBarAction? action,
}) {
  // Dismiss any existing snackbars
  ScaffoldMessenger.of(context).clearSnackBars();

  // Create and show the snackbar
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: 16.0,
      ),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    elevation: elevation,
    behavior: SnackBarBehavior.floating,
    margin: margin,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
    ),
    action: action,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
