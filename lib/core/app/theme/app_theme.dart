import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tombala/core/app/theme/app_text_theme.dart';

import '../../../components/view_models/view_model.dart';
import '../../locator/locator.dart';

class AppTheme {
  AppTheme._();

  static final ViewModel _viewModel = locator<ViewModel>();

  static ThemeData get themeDark => FlexThemeData.dark(
        scheme: FlexScheme.blueWhale,
        textTheme: AppTextTheme().textTheme,
      );
  static ThemeData get themeLight => FlexThemeData.light(
        scheme: FlexScheme.blueWhale,
        textTheme: AppTextTheme().textTheme,
      );

  static ThemeData get theme => _viewModel.isDarkModel ? themeDark : themeLight;

  static TextTheme get textStyle => theme.textTheme;
}
