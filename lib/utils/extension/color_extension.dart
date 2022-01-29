import 'package:flutter/material.dart';
import 'package:tombala/utils/constants/color_constants.dart';

extension ColorExtension on ColorConstants {
  Color? get transparentColor => Color(int.parse("0xff" + transparent.toString()));
}
