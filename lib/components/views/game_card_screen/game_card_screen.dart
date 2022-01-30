import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/components/widgets/chat_sheet.dart';
import 'package:tombala/components/widgets/winner_container_widget.dart';
import 'package:tombala/core/app/duration/app_duration.dart';
import 'package:tombala/core/constants/string_constants.dart';
import '../../view_models/view_model.dart';
import '../../../core/locator/locator.dart';
import '../../../core/app/color/app_color.dart';
import '../../../core/app/icon/app_icon.dart';
import '../../../core/app/navigator/app_navigator.dart';
import '../../../core/app/size/app_size.dart';
import '../../../core/app/theme/app_theme.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/routes/routes.dart';

import '../../widgets/snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameCardScreen extends StatefulWidget {
  const GameCardScreen({Key? key}) : super(key: key);

  @override
  State<GameCardScreen> createState() => _GameCardScreenState();
}

class _GameCardScreenState extends State<GameCardScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    super.initState();

    if (_viewModel.roomModel.roomId == null) {
      AppNavigator(context: context).push(route: Routes.home);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _viewModel.roomStream();
    _viewModel.messageStream();

    autoTakeNumberMethod();

    takenNumberMethod();

    winnerReactionsMethod();
  }

  void takenNumberMethod() {
    _viewModel.takenNumberReaction = reaction(
      (_) => _viewModel.takenNumber,
      (v) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.amber,
            "${AppLocalizations.of(context)!.takenNumber} ${_viewModel.takenNumber}",
          ),
        );
      },
      delay: 1000,
    );
  }

  void winnerReactionsMethod() {
    _viewModel.firstWinnerReaction = reaction(
      (_) => _viewModel.roomModel.roomFirstWinner,
      (firstWinner) =>
          _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
        snackBar(
          Colors.green,
          "${AppLocalizations.of(context)!.theWinner1} : $firstWinner",
        ),
      ),
      delay: 1000,
    );

    _viewModel.firstWinnerReaction = reaction(
      (_) => _viewModel.roomModel.roomSecondWinner,
      (secondWinner) =>
          _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
        snackBar(
          Colors.green,
          "${AppLocalizations.of(context)!.theWinner2} : $secondWinner",
        ),
      ),
      delay: 1000,
    );

    _viewModel.firstWinnerReaction = reaction(
      (_) => _viewModel.roomModel.roomThirdWinner,
      (thirdWinner) =>
          _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
        snackBar(
          Colors.green,
          "${AppLocalizations.of(context)!.theWinner3} : $thirdWinner",
        ),
      ),
      delay: 1000,
    );
  }

  void autoTakeNumberMethod() {
    if (_viewModel.roomModel.roomCreator == _viewModel.playerModel.userName &&
        _viewModel.isGameAutoTakeNumber &&
        _viewModel.allNumbersList.isNotEmpty) {
      Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) => _viewModel.takeNumber(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.takenNumberReaction?.reaction.dispose();

    _viewModel.firstWinnerReaction?.reaction.dispose();
    _viewModel.secondWinnerReaction?.reaction.dispose();
    _viewModel.thirdWinnerReaction?.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildObserver();
  }

  Observer buildObserver() {
    return Observer(
      builder: (_) {
        return willPopScope();
      },
    );
  }

  WillPopScope willPopScope() {
    return WillPopScope(
      onWillPop: () => Future.sync(
        () {
          return onWillPopMethod();
        },
      ),
      child: scaffoldMessenger(),
    );
  }

  bool onWillPopMethod() {
    if (_viewModel.roomModel.roomStatus != "finished") {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.attension),
          content: Text(AppLocalizations.of(context)!.reallyWantToLEave),
          actions: <Widget>[
            TextButton(
              onPressed: () => AppNavigator(context: context).pop(),
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () => AppNavigator(context: context).popUntilFirst(),
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        ),
      );
    } else {
      AppNavigator(context: context).popUntilFirst();
    }

    return false;
  }

  ScaffoldMessenger scaffoldMessenger() {
    return ScaffoldMessenger(
      key: _viewModel.gameCardScaffoldMessengerKey,
      child: scaffold(),
    );
  }

  Scaffold scaffold() {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  Widget setWinnerFab() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await setWinnerFabMethod();
      },
      label: winnerLabelFabMethod(),
    );
  }

  Future<void> setWinnerFabMethod() async {
    if (_viewModel.roomModel.roomFirstWinner == "") {
      final isWin = await _viewModel.winnerControl(1);
      if (!isWin) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.red,
            AppLocalizations.of(context)!.controlYourNumbers,
          ),
        );
      }
    } else if (_viewModel.roomModel.roomSecondWinner == "") {
      final isWin = await _viewModel.winnerControl(2);
      if (!isWin) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.red,
            AppLocalizations.of(context)!.controlYourNumbers,
          ),
        );
      }
    } else if (_viewModel.roomModel.roomThirdWinner == "") {
      final isWin = await _viewModel.winnerControl(3);
      if (!isWin) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.red,
            AppLocalizations.of(context)!.controlYourNumbers,
          ),
        );
      }
    } else {
      AppNavigator(context: context).popUntilFirst();
    }
  }

  Text winnerLabelFabMethod() {
    if (_viewModel.roomModel.roomFirstWinner == "") {
      return Text(
        AppLocalizations.of(context)!.setWinner1,
      );
    } else if (_viewModel.roomModel.roomSecondWinner == "") {
      return Text(
        AppLocalizations.of(context)!.setWinner2,
      );
    } else if (_viewModel.roomModel.roomThirdWinner == "") {
      return Text(
        AppLocalizations.of(context)!.setWinner3,
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.wantToPlay,
      );
    }
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        StringConstants.appName,
      ),
      actions: [appBarActionPadding()],
    );
  }

  Widget appBarActionPadding() {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(right: context.lowValue),
          child: FutureBuilder(
            future: Future.delayed(AppDuration.highDuration * 2),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.done
                ? Text(
                    _viewModel.takenNumbersListFromDatabase.isEmpty
                        ? AppLocalizations.of(context)!.takenNumber
                        : "${AppLocalizations.of(context)!.takenNumber} ${_viewModel.takenNumbersListFromDatabase.elementAt(
                            _viewModel.takenNumbersListFromDatabase.length - 1,
                          )}",
                  )
                : Text(
                    AppLocalizations.of(context)!.takenNumber,
                  ),
          )),
    );
  }

  Center body() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSize.lowHeightSizedBox,
            if (_viewModel.roomModel.roomFirstWinner!.isNotEmpty)
              WinnerContainerWidget(
                text:
                    "${AppLocalizations.of(context)!.theWinner1} : ${_viewModel.roomModel.roomFirstWinner}",
              ),
            if (_viewModel.roomModel.roomSecondWinner!.isNotEmpty)
              WinnerContainerWidget(
                text:
                    "${AppLocalizations.of(context)!.theWinner2} : ${_viewModel.roomModel.roomSecondWinner}",
              ),
            if (_viewModel.roomModel.roomThirdWinner!.isNotEmpty)
              WinnerContainerWidget(
                text:
                    "${AppLocalizations.of(context)!.theWinner3} : ${_viewModel.roomModel.roomThirdWinner}",
              ),
            gameCardWidget(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AppSize.lowWidthSizedBox,
                  openGameTableElevatedButton(),
                  AppSize.lowWidthSizedBox,
                  openChatOutlinedButton(),
                  AppSize.lowWidthSizedBox,
                  if (_viewModel.roomModel.roomCreator ==
                          _viewModel.playerModel.userName &&
                      !_viewModel.isGameAutoTakeNumber)
                    takeNumberOutlinedButton(),
                  AppSize.lowWidthSizedBox,
                ],
              ),
            ),
            AppSize.lowHeightSizedBox,
            setWinnerFab(),
            AppSize.lowHeightSizedBox,
          ],
        ),
      ),
    );
  }

  Widget gameCardWidget() {
    return Container(
      decoration: BoxDecoration(
        color: _viewModel.randomColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSize.medium),
        border: Border.all(
          color: _viewModel.randomColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      width: context.width * 0.8,
      padding: context.paddingLow,
      margin: context.paddingLow,
      child: GridView.builder(
        //listeyi canlı tutar
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 27,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 3,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (context, index) =>
            index.isEven ? numberListItem(index) : blankListItem(),
      ),
    );
  }

  Container numberListItem(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _viewModel.randomColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.low),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _viewModel.randomColor),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.low)),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.low)),
            focusColor: AppColor.greenColor?.withOpacity(0.1),
            splashColor: AppColor.greenColor?.withOpacity(0.1),
            hoverColor: AppColor.greenColor?.withOpacity(0.1),
            highlightColor: AppColor.greenColor?.withOpacity(0.1),
            onTap: () {
              if (_viewModel.takenNumbersListFromDatabase
                  .contains(_viewModel.cardNumbersList[index ~/ 2])) {
                _viewModel.takenNumbersMap.update(
                  _viewModel.cardNumbersList[index ~/ 2],
                  (value) => true,
                );

                setState(() {});
              }
            },
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: _viewModel.takenNumbersMap[
                              _viewModel.cardNumbersList[index ~/ 2]]!
                          ? AppColor.greenColor?.withOpacity(0.1)
                          : AppColor.transparentColor,
                      border: Border.all(
                        width: 3,
                        color: _viewModel.takenNumbersMap[
                                _viewModel.cardNumbersList[index ~/ 2]]!
                            ? AppColor.greenColor!.withOpacity(0.6)
                            : AppColor.transparentColor!,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.high)),
                    ),
                  ),
                  Text(
                    _viewModel.cardNumbersList[index ~/ 2].toString(),
                    style: AppTheme.textStyle.headline5?.copyWith(
                      color: _viewModel.randomColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container blankListItem() {
    return Container(
      decoration: BoxDecoration(
        color: _viewModel.randomColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.low),
        ),
      ),
    );
  }

  ElevatedButton openGameTableElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => gameTableWidget(),
        );
      },
      child: Text(AppLocalizations.of(context)!.showGameTable),
    );
  }

  Widget gameTableWidget() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.height / 8,
      ),
      itemCount: 99,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: gameTableBoxDecorationColorMethod(index),
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(AppSize.high),
            ),
            child: Center(
              child: Text("${index + 1}", style: AppTheme.textStyle.headline5),
            ),
          ),
        );
      },
    );
  }

  Color? gameTableBoxDecorationColorMethod(int index) {
    if (_viewModel.roomModel.roomCreator == _viewModel.playerModel.userName) {
      return _viewModel.takenNumbersList.contains(index + 1)
          ? AppColor.greenColor
          : AppColor.redColor;
    } else {
      return _viewModel.takenNumbersListFromDatabase.contains(index + 1)
          ? AppColor.greenColor
          : AppColor.redColor;
    }
  }

  OutlinedButton openChatOutlinedButton() {
    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet<dynamic>(
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => const ChatBottomSheetWidget(),
        );
      },
      icon: AppIcon.chatIcon,
      label: Text(AppLocalizations.of(context)!.chat),
    );
  }

  OutlinedButton takeNumberOutlinedButton() {
    return OutlinedButton(
      onPressed: () async {
        if (_viewModel.roomModel.roomThirdWinner!.isEmpty) {
          await _viewModel.takeNumber();
        } else {}
      },
      child: Text(AppLocalizations.of(context)!.takeNumber),
    );
  }
}
