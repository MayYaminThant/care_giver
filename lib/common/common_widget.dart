import 'package:flutter/material.dart';

void showSimpleSnackBar(
  BuildContext context,
  String text,
  Color bgColor, {
  VoidCallback? dismissCallback,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: (bgColor),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: dismissCallback ?? () {},
      ),
    ),
  );
}
