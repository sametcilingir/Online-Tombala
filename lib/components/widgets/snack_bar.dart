import 'package:flutter/material.dart';

class SnackBarWidget {
  final Color color;
  final String message;
  const SnackBarWidget({required this.color, required this.message});

  SnackBar get snackBar => SnackBar(
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(message),
      );
}
