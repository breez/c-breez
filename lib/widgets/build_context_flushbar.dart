import 'package:flutter/material.dart';

extension BuildContextFlushbar on BuildContext {
  void flushbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
