import 'package:flutter/material.dart';
import 'package:tombala/core/extension/context_extension.dart';

class WinnerContainerWidget extends StatelessWidget {
  const WinnerContainerWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: context.paddingLow,
        child: Text(
          text,
        ),
      ),
    );
  }
}
