import 'package:flutter/material.dart';

class Utils {
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }
}
