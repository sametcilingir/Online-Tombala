import 'package:flutter/material.dart';
import '../../core/app/theme/app_theme.dart';

SnackBar snackBar(Color color, String message) {
  return SnackBar(
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    content: Text(
      message,
      style: AppTheme.textStyle.subtitle1,
    ),
  );
}
