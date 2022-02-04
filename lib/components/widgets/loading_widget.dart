import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:tombala/core/app/theme/app_theme.dart';

import '../view_models/view_model.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
    required ViewModel viewModel,
    required Widget child,
  })  : _viewModel = viewModel,
        _child = child,
        super(key: key);

  final ViewModel? _viewModel;
  final Widget? _child;

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return LoadingOverlay(
          color: AppTheme.theme.colorScheme.primary,
          opacity: 0.6,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.theme.colorScheme.secondary,
            ),
          ),
          isLoading: widget._viewModel?.viewState == ViewState.busy,
          child: widget._child ?? Container(),
        );
      },
    );
  }
}
