import 'package:flutter/material.dart';

class NavigatorUtils {
  static Future<dynamic> push(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<dynamic> pushAndRemoveUntil(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  }

  static dynamic pop(
    BuildContext context, {
    final dynamic result,
  }) {
    return Navigator.pop(context, result);
  }
}
