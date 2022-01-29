import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:tombala/components/view_models/view_model.dart';
import 'package:tombala/utils/locator/locator.dart';

class AppTheme {
  final ViewModel _viewModel = locator<ViewModel>();

  ThemeData get themeDark => FlexThemeData.dark(scheme: FlexScheme.aquaBlue);
  ThemeData get themeLight => FlexThemeData.light(scheme: FlexScheme.aquaBlue);

  ThemeData get theme => _viewModel.isDarkModel ? themeDark : themeLight;

  TextStyle? get headline1 => theme.textTheme.headline1;
  TextStyle? get headline2 => theme.textTheme.headline2;
  TextStyle? get headline3 => theme.textTheme.headline3;
  TextStyle? get headline4 => theme.textTheme.headline4;
  TextStyle? get headline5 => theme.textTheme.headline5;
  TextStyle? get headline6 => theme.textTheme.headline6;
  TextStyle? get subtitle1 => theme.textTheme.subtitle1;
  TextStyle? get subtitle2 => theme.textTheme.subtitle2;
  TextStyle? get bodyText1 => theme.textTheme.bodyText1;
  TextStyle? get bodyText2 => theme.textTheme.bodyText2;
  TextStyle? get button => theme.textTheme.button;
  TextStyle? get caption => theme.textTheme.caption;
  TextStyle? get overline => theme.textTheme.overline;
}
