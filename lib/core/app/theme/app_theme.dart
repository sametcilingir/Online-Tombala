import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../components/view_models/view_model.dart';
import '../../locator/locator.dart';

class AppTheme {
  AppTheme._();

  static final ViewModel _viewModel = locator<ViewModel>();

  static ThemeData get themeDark =>
      FlexThemeData.dark(scheme: FlexScheme.aquaBlue);
  static ThemeData get themeLight =>
      FlexThemeData.light(scheme: FlexScheme.aquaBlue);

  static ThemeData get theme => _viewModel.isDarkModel ? themeDark : themeLight;

  static TextStyle? get headline1 => theme.textTheme.headline1;
  static TextStyle? get headline2 => theme.textTheme.headline2;
  static TextStyle? get headline3 => theme.textTheme.headline3;
  static TextStyle? get headline4 => theme.textTheme.headline4;
  static TextStyle? get headline5 => theme.textTheme.headline5;
  static TextStyle? get headline6 => theme.textTheme.headline6;
  static TextStyle? get subtitle1 => theme.textTheme.subtitle1;
  static TextStyle? get subtitle2 => theme.textTheme.subtitle2;
  static TextStyle? get bodyText1 => theme.textTheme.bodyText1;
  static TextStyle? get bodyText2 => theme.textTheme.bodyText2;
  static TextStyle? get button => theme.textTheme.button;
  static TextStyle? get caption => theme.textTheme.caption;
  static TextStyle? get overline => theme.textTheme.overline;
}
