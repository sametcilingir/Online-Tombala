import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/app/color/app_color.dart';
import '../../../core/app/duration/app_duration.dart';
import '../../../core/app/theme/app_theme.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/locator/locator.dart';
import '../../widgets/loading_widget.dart';
import '../../view_models/view_model.dart';

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
  void initState() {
    super.initState();
    _viewModel.reInit();
  }

  @override
  Widget build(BuildContext context) {
    return buildWillPopScope();
  }

  WillPopScope buildWillPopScope() {
    return WillPopScope(
      onWillPop: () => Future.sync(() {
        _viewModel.homePageController.animateToPage(
          0,
          duration: AppDuration.lowDuration,
          curve: Curves.easeIn,
        );
        return false;
      }),
      child: loading(),
    );
  }

  Widget loading() {
    return Observer(builder: (_) {
      return LoadingWidget(
        viewModel: _viewModel,
        child: scaffold(),
      );
    });
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
      title: appBarTitleText(),
      centerTitle: true,
      actions: [
        appBarActionIconButton(),
      ],
    );
  }

  Widget appBarLeadingTextButton() {
    return TextButton(
      onPressed: () {
        _viewModel.isENLocal = !_viewModel.isENLocal;
      },
      child: appBarLeadingTextButtonText(),
    );
  }

  Widget appBarLeadingTextButtonText() {
    return Text(
      _viewModel.isENLocal ? StringConstants.langTr : StringConstants.langEn,
      style: AppTheme.textStyle.button!.copyWith(color: Colors.white),
    );
  }

  Widget appBarTitleText() {
    return Text(
      StringConstants.appName,
     
    );
  }

  Widget appBarActionIconButton() {
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
