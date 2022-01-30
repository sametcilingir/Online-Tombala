import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../view_models/view_model.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
    required viewModel,
    required child,
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
    return Observer(builder: (_) {
      return LoadingOverlay(
        color: Colors.grey[200],
        opacity: 0.6,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        isLoading: widget._viewModel?.viewState == ViewState.Busy,
        child: widget._child ?? Container(),
      );
    });
  }
}
