import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../core/app/color/app_color.dart';
import '../../../core/app/icon/app_icon.dart';
import '../../../core/app/navigator/app_navigator.dart';
import '../../../core/app/size/app_size.dart';
import '../../../core/app/theme/app_theme.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/locator/locator.dart';
import '../../../core/routes/routes.dart';
import '../../view_models/view_model.dart';
import '../../widgets/chat_sheet.dart';
import '../../widgets/loading_widget.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    super.initState();
    if (_viewModel.roomModel.roomId == null) {
      AppNavigator(context: context).push(route: Routes.home);
    }
    _viewModel.createGameCard();

    if (_viewModel.roomModel.roomCreator != _viewModel.playerModel.userName) {
      _viewModel.startGameReaction = reaction(
        (_) => _viewModel.roomModel.roomStatus,
        (string) => string == "started"
            ? AppNavigator(context: context).push(route: Routes.gameCard)
            : null,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _viewModel.roomStream();
    _viewModel.playersStream();
    _viewModel.messageStream();
  }

  @override
  void dispose() {
    super.dispose();

    _viewModel.startGameReaction?.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildObserver();
  }

  Observer buildObserver() {
    return Observer(
      builder: (_) {
        return loading();
      },
    );
  }

  LoadingWidget loading() {
    return LoadingWidget(
      viewModel: _viewModel,
      child: scaffold(),
    );
  }

  Scaffold scaffold() {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSize.mediumHeightSizedBox,
              roomCodeText(),
              AppSize.mediumHeightSizedBox,
              playersContainer(),
              AppSize.mediumHeightSizedBox,
              if (_viewModel.roomModel.roomCreator ==
                  _viewModel.playerModel.userName)
                roomCreatorColumn(),
              if (_viewModel.roomModel.roomCreator !=
                  _viewModel.playerModel.userName)
                roomPlayerPadding(),
              setPlayerStatusRow(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: appBarLeadingBackButton(),
      actions: [
        if (_viewModel.roomModel.roomCreator == _viewModel.playerModel.userName)
          Padding(
            padding: context.paddingLow,
            child: appBarActionOutlinedButton(),
          ),
      ],
    );
  }

  IconButton appBarLeadingBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        AppNavigator(context: context).pop();
      },
    );
  }

  OutlinedButton appBarActionOutlinedButton() {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      onPressed: () async {
        await _viewModel.deleteGame();
        AppNavigator(context: context).pop();
      },
      child: Row(
        children: [
          AppIcon.colorfulIcon(
            appColor: Colors.white,
            appIcon: AppIcon.close,
          ),
          AppSize.lowWidthSizedBox,
          Text(
            AppLocalizations.of(context)!.deleteGame,
            style: AppTheme.textStyle.button!.copyWith(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Text roomCodeText() {
    return Text(
      "${AppLocalizations.of(context)!.gameCode}: ${_viewModel.roomModel.roomCode}",
      style: AppTheme.textStyle.headline4?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container playersContainer() {
    return Container(
      height: context.height * 0.5,
      width: 500,
      margin: context.paddingLow,
      decoration: BoxDecoration(
        color: AppTheme.theme.colorScheme.primary.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppSize.low,
          ),
        ),
      ),
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.players,
              style: AppTheme.textStyle.headline4,
            ),
            AppSize.mediumHeightSizedBox,
            playersList(),
            AppSize.lowHeightSizedBox,
            openChatOutlinedButton()
          ],
        ),
      ),
    );
  }

  SingleChildScrollView playersList() {
    return SingleChildScrollView(
      child: SizedBox(
        height: context.height * 0.32,
        child: ListView.builder(
          itemCount: _viewModel.playersList!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => playersListItem(context, index),
        ),
      ),
    );
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

  Padding playersListItem(BuildContext context, int index) {
    return Padding(
      padding: context.paddingLow,
      child: ListTile(
        title: Text(
          _viewModel.playersList![index].userName.toString(),
          style: AppTheme.textStyle.headline6,
        ),
        subtitle: Text(
          _viewModel.playersList![index].userStatus == true
              ? AppLocalizations.of(context)!.playersReady
              : AppLocalizations.of(context)!.playersNotReady,
          style: AppTheme.textStyle.subtitle1,
        ),
        trailing: _viewModel.playersList![index].userStatus == true
            ? AppIcon.colorfulIcon(
                appColor: AppColor.greenColor,
                appIcon: AppIcon.check,
              )
            : AppIcon.colorfulIcon(
                appColor: AppColor.redColor,
                appIcon: AppIcon.info,
              ),
      ),
    );
  }

  Column roomCreatorColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.autoTakeNumber,
            ),
            Switch(
              value: _viewModel.isGameAutoTakeNumber,
              onChanged: (value) {
                _viewModel.isGameAutoTakeNumber = value;
              },
            ),
          ],
        ),
        if (_viewModel.roomModel.roomStatus != "started")
          startGameElevatedButton()
        else
          errorWidget(),
      ],
    );
  }

  ElevatedButton startGameElevatedButton() {
    return ElevatedButton(
      onPressed: () async {
        final isGameStarted = await _viewModel.startGame();
        if (isGameStarted) {
          AppNavigator(context: context).push(
            route: Routes.gameCard,
          );
        }
      },
      child: Text(
        AppLocalizations.of(context)!.startGame,
      ),
    );
  }

  Center errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.isAlreadyStarted),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.back,
            ),
          ),
        ],
      ),
    );
  }

  Padding roomPlayerPadding() {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        children: [
          const SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          ),
          AppSize.mediumHeightSizedBox,
          Text(
            "${_viewModel.roomModel.roomCreator} ${AppLocalizations.of(context)!.waitingToStart}",
            style: AppTheme.textStyle.subtitle1,
            textAlign: TextAlign.center,
          ),
          AppSize.mediumHeightSizedBox,
        ],
      ),
    );
  }

  Row setPlayerStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () async {
            await _viewModel.setPlayerStatus(playerStatus: false);
          },
          child: Text(
            AppLocalizations.of(context)!.notReady,
          ),
        ),
        AppSize.mediumWidthSizedBox,
        ElevatedButton(
          onPressed: () async {
            await _viewModel.setPlayerStatus(playerStatus: true);
          },
          child: Text(
            AppLocalizations.of(context)!.ready,
          ),
        ),
      ],
    );
  }
}
