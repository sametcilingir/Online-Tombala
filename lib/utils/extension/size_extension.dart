import 'package:flutter/material.dart';
import 'package:tombala/utils/constants/size_constants.dart';

extension SizeExtension on SizeConstants {
  SizedBox get zeroBox => SizedBox(height: zero, width: zero);


  SizedBox get lowHeight => SizedBox(height: low,);
  SizedBox get mediumHeight => SizedBox(height: medium,);
  SizedBox get highHeight => SizedBox(height: high,);

  SizedBox get lowWidth => SizedBox(width: low,);
  SizedBox get mediumWidth => SizedBox(width: medium,);
  SizedBox get highWidth => SizedBox(width: high,);
}
