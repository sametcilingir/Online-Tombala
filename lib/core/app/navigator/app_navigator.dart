import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator({
    required context,
  }) : _context = context;

  final BuildContext? _context;

  push({required String route}) {
    Navigator.pushNamed(_context!, route);
  }

  popUntilFirst() {
    Navigator.of(_context!).popUntil((route) => route.isFirst);
  }

  pop() {
    Navigator.pop(_context!);
  }
}
