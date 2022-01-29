import 'package:flutter/material.dart';
import 'package:tombala/components/widgets/loading_widget.dart';
import 'package:tombala/utils/constants/duration_constants.dart';
import 'package:tombala/utils/constants/string_constants.dart';
import 'package:tombala/utils/extension/duration_extension.dart';
import 'package:tombala/utils/theme/app_theme.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';

import 'page_view/join_form_screen.dart';
import 'page_view/login_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ViewModel get _viewModel => locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return buildWillPopScope();
  }

  WillPopScope buildWillPopScope() {
    return WillPopScope(
        onWillPop: () => Future.sync(() {
              _viewModel.homePageController.animateToPage(
                0,
                duration: DurationConstants().durationLow,
                curve: Curves.easeIn,
              );
              return false;
            }),
        child: loading());
  }

  LoadingWidget loading() {
    return LoadingWidget(
      viewModel: _viewModel,
      child: scaffold(),
    );
  }

  Scaffold scaffold() {
    return Scaffold(
      key: _viewModel.homeScaffoldMessengerKey,
      appBar: appBar(),
      body: pageView(),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: appBarLeadingTextButton(),
      elevation: 0,
      title: appBarTitleText(),
      centerTitle: true,
      actions: [
        appBarActionIconButton(),
      ],
    );
  }

  TextButton appBarLeadingTextButton() {
    return TextButton(
      child: appBarLeadingTextButtonText(),
      onPressed: () {
        _viewModel.isENLocal = !_viewModel.isENLocal;
      },
    );
  }

  Text appBarLeadingTextButtonText() {
    return Text(
      _viewModel.isENLocal ? StringConstants.langTr : StringConstants.langEn,
    );
  }

  Text appBarTitleText() {
    return Text(
      StringConstants.appName,
      style: AppTheme().headline5,
      //
    );
  }

  IconButton appBarActionIconButton() {
    return IconButton(
      icon: Icon(_viewModel.isDarkModel ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        _viewModel.isDarkModel = !_viewModel.isDarkModel;
      },
    );
  }

  PageView pageView() {
    return PageView(
      allowImplicitScrolling: true,
      controller: _viewModel.homePageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        LoginFormScreen(),
        JoinFormScreen(),
      ],
    );
  }
}
