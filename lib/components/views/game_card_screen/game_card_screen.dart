import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../../core/app/color/app_color.dart';
import '../../../core/app/icon/app_icon.dart';
import '../../../core/app/navigator/app_navigator.dart';
import '../../../core/app/size/app_size.dart';
import '../../../core/app/theme/app_theme.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/routes/routes.dart';
import '../../../core/locator/locator.dart';
import '../../widgets/snack_bar.dart';
import '../../view_models/view_model.dart';
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
      Navigator.of(context).pushNamed(Routes.home);
    }

    winnerReactionsMethod();


    takenNumberMethod();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _viewModel.roomStream();
    _viewModel.messageStream();


    autoTakeNumberMethod();
  }

  void takenNumberMethod() {
    _viewModel.takenNumberReaction =
        reaction((_) => _viewModel.takenNumber, (v) {
      _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
        snackBar(
          Colors.amber,
          "${AppLocalizations.of(context)!.takenNumber} ${_viewModel.takenNumber}",
        ),
      );
    }, delay: 1000);
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
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomSecondWinner,
        (secondWinner) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              snackBar(
                Colors.green,
                "${AppLocalizations.of(context)!.theWinner2} : $secondWinner",
              ),
            ),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomThirdWinner,
        (thirdWinner) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              snackBar(
                Colors.green,
                "${AppLocalizations.of(context)!.theWinner3} : $thirdWinner",
              ),
            ),
        delay: 1000);
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
    _viewModel.takenNumberReaction;
    _viewModel.firstWinnerReaction;
    _viewModel.secondWinnerReaction;
    _viewModel.thirdWinnerReaction;
  }

  @override
  Widget build(BuildContext context) {
    return buildObserver(context);
  }

  Observer buildObserver(BuildContext context) {
    return Observer(
      builder: (_) {
        return willPopScope(context);
      },
    );
  }

  WillPopScope willPopScope(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(
        () {
          return onWillPopMethod(context);
        },
      ),
      child: scaffoldMessenger(context),
    );
  }

  bool onWillPopMethod(BuildContext context) {
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

  ScaffoldMessenger scaffoldMessenger(BuildContext context) {
    return ScaffoldMessenger(
      key: _viewModel.gameCardScaffoldMessengerKey,
      child: scaffold(context),
    );
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      floatingActionButton: setWinnerFab(context),
      appBar: appBar(context),
      body: body(context),
    );
  }

  Padding setWinnerFab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSize.high,
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          await fabOnPressedMethod(context);
        },
        backgroundColor: AppColor.amberColor,
        icon: AppIcon.checkIcon,
        label: labelFabMethod(context),
      ),
    );
  }

  Future<void> fabOnPressedMethod(BuildContext context) async {
    if (_viewModel.roomModel.roomFirstWinner == "") {
      bool isWin = await _viewModel.winnerControl(1);
      if (!isWin) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.red,
            AppLocalizations.of(context)!.controlYourNumbers,
          ),
        );
      }
    } else if (_viewModel.roomModel.roomSecondWinner == "") {
      bool isWin = await _viewModel.winnerControl(2);
      if (!isWin) {
        _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(
            Colors.red,
            AppLocalizations.of(context)!.controlYourNumbers,
          ),
        );
      }
    } else if (_viewModel.roomModel.roomThirdWinner == "") {
      bool isWin = await _viewModel.winnerControl(3);
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

  Text labelFabMethod(BuildContext context) {
    if (_viewModel.roomModel.roomFirstWinner == "") {
      return Text(AppLocalizations.of(context)!.setWinner1);
    } else if (_viewModel.roomModel.roomSecondWinner == "") {
      return Text(AppLocalizations.of(context)!.setWinner2);
    } else if (_viewModel.roomModel.roomThirdWinner == "") {
      return Text(AppLocalizations.of(context)!.setWinner3);
    } else {
      return Text(AppLocalizations.of(context)!.wantToPlay);
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leadingWidth: 300,
      leading: appBarLeadingScrollView(context),
      actions: [appBarActionPadding()],
    );
  }

  SingleChildScrollView appBarLeadingScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _viewModel.roomModel.roomFirstWinner!.isNotEmpty
              ? Text(AppLocalizations.of(context)!.theWinner1 +
                  _viewModel.roomModel.roomFirstWinner.toString())
              : AppSize.zeroSizedBox,
          AppSize.lowHeightSizedBox,
          _viewModel.roomModel.roomSecondWinner!.isNotEmpty
              ? Text(AppLocalizations.of(context)!.theWinner2 +
                  _viewModel.roomModel.roomSecondWinner.toString())
              : AppSize.zeroSizedBox,
          AppSize.lowHeightSizedBox,
          _viewModel.roomModel.roomThirdWinner!.isNotEmpty
              ? Text(AppLocalizations.of(context)!.theWinner3 +
                  _viewModel.roomModel.roomThirdWinner.toString())
              : AppSize.zeroSizedBox,
          AppSize.lowHeightSizedBox,
        ],
      ),
    );
  }

  Padding appBarActionPadding() {
    return Padding(
      padding: context.paddingMedium,
      child: Text(
        _viewModel.takenNumbersListFromDatabase.length < 2
            ? ""
            : "${AppLocalizations.of(context)!.takenNumber} ${_viewModel.takenNumbersListFromDatabase.elementAt(
                _viewModel.takenNumbersListFromDatabase.length - 2,
              )}",
      ),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gameCardWidget(context),
            AppSize.mediumHeightSizedBox,
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => gameTableWidget(_viewModel),
                );
              },
              child: Text(AppLocalizations.of(context)!.showGameTable),
            ),
            (() {
              if (_viewModel.roomModel.roomCreator ==
                  _viewModel.playerModel.userName) {
                if (!_viewModel.isGameAutoTakeNumber) {
                  return OutlinedButton(
                    onPressed: () async {
                      if (_viewModel.roomModel.roomThirdWinner!.isEmpty) {
                        await _viewModel.takeNumber();
                      } else {}
                    },
                    child: Text(AppLocalizations.of(context)!.takeNumber),
                  );
                } else {
                  return AppSize.zeroSizedBox;
                }
              } else {
                return AppSize.zeroSizedBox;
              }
            }()),
            AppSize.lowHeightSizedBox,
            _viewModel.roomModel.roomFirstWinner!.isNotEmpty
                ? Text(
                    "${AppLocalizations.of(context)!.theWinner1} : ${_viewModel.roomModel.roomFirstWinner}")
                : AppSize.zeroSizedBox,
            AppSize.lowHeightSizedBox,
            _viewModel.roomModel.roomSecondWinner!.isNotEmpty
                ? Text(
                    "${AppLocalizations.of(context)!.theWinner2} : ${_viewModel.roomModel.roomSecondWinner}")
                : AppSize.zeroSizedBox,
            AppSize.lowHeightSizedBox,
            _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                ? Text(
                    "${AppLocalizations.of(context)!.theWinner3} : ${_viewModel.roomModel.roomThirdWinner}")
                : AppSize.zeroSizedBox,
            const SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget gameCardWidget(BuildContext context) {
    return SizedBox(
      width: 400,
      child: GridView.builder(
        //listeyi canlı tutar
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 27,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 3,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (context, index) =>
            index.floor().isEven ? numberListItem(index) : blankListItem(),
      ),
    );
  }

  Container numberListItem(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: _viewModel.randomColor,
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppSize.medium))),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _viewModel.randomColor),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.medium)),
          ),
          child: InkWell(
            borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.medium)),
            focusColor: AppColor.greenColor?.withOpacity(0.1),
            splashColor: AppColor.greenColor?.withOpacity(0.1),
            hoverColor: AppColor.greenColor?.withOpacity(0.1),
            highlightColor: AppColor.greenColor?.withOpacity(0.1),
            onTap: () {
              if (_viewModel.takenNumbersListFromDatabase
                  .contains(_viewModel.cardNumbersList[index ~/ 2])) {
                _viewModel.takenNumbersMap.update(
                    _viewModel.cardNumbersList[index ~/ 2], (value) => true);

                setState(() {});
              }
            },
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: _viewModel.takenNumbersMap[
                              _viewModel.cardNumbersList[index ~/ 2]]!
                          ? AppColor.greenColor?.withOpacity(0.3)
                          : AppColor.transparentColor,
                      border: Border.all(
                        width: 4,
                        color: _viewModel.takenNumbersMap[
                                _viewModel.cardNumbersList[index ~/ 2]]!
                            ? AppColor.greenColor!.withOpacity(0.5)
                            : AppColor.transparentColor!,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.high)),
                    ),
                  ),
                  Text(
                    _viewModel.cardNumbersList[index ~/ 2].toString(),
                    style: AppTheme.headline5?.copyWith(
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
          border: Border.all(
              // color: Colors.white
              ),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppSize.medium))),
    );
  }

  Widget gameTableWidget(ViewModel viewModel) {
    return GridView.builder(
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.height / 8),
      itemCount: 99,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: (() {
                if (_viewModel.roomModel.roomCreator ==
                    _viewModel.playerModel.userName) {
                  return _viewModel.takenNumbersList.contains(index + 1)
                      ? AppColor.greenColor
                      : AppColor.redColor;
                } else {
                  return _viewModel.takenNumbersListFromDatabase
                          .contains(index + 1)
                      ? AppColor.greenColor
                      : AppColor.redColor;
                }
              }()),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppSize.high),
            ),
            child: Center(
              child: Text("${index + 1}", style: AppTheme.headline5),
            ),
          ),
        );
      },
    );
  }
}
