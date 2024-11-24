// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  final String message;

  const FailureWidget({
    super.key,
    this.message = 'something went wrong',
  });

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
