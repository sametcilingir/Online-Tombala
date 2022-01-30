import 'package:flutter/material.dart';
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
import '../../widgets/chat_sheet.dart';
import '../../widgets/loading_widget.dart';
import '../../view_models/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    _viewModel.roomStream();
    _viewModel.playersStream();
    _viewModel.messageStream();

    if (_viewModel.roomModel.roomCreator != _viewModel.playerModel.userName) {
      _viewModel.startGameReaction = reaction(
          (_) => _viewModel.roomModel.roomStatus,
          (string) => string == "started"
              ? AppNavigator(context: context).push(route: Routes.gameCard)
              : null);
    }
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
    return Observer(builder: (_) {
      return loading();
    });
  }

  LoadingWidget loading() {
    return LoadingWidget(
      viewModel: _viewModel,
      child: scaffold(),
    );
  }

  Scaffold scaffold() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appBar(),
              roomCodeText(),
              AppSize.mediumHeightSizedBox,
              playersContainer(),
              AppSize.mediumHeightSizedBox,
              _viewModel.roomModel.roomCreator ==
                      _viewModel.playerModel.userName
                  ? roomCreatorColumn()
                  : AppSize.zeroSizedBox,
              _viewModel.roomModel.roomCreator !=
                      _viewModel.playerModel.userName
                  ? roomPlayerPadding()
                  : AppSize.zeroSizedBox,
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: appBareLeadingBackButton(),
      actions: [
        _viewModel.roomModel.roomCreator == _viewModel.playerModel.userName
            ? Padding(
                padding: context.paddingLow,
                child: appBarActionOutlinedButton(),
              )
            : AppSize.zeroSizedBox,
      ],
    );
  }

  BackButton appBareLeadingBackButton() {
    return BackButton(
      onPressed: () {
        AppNavigator(context: context).pop();
      },
    );
  }

  OutlinedButton appBarActionOutlinedButton() {
    return OutlinedButton.icon(
      onPressed: () async {
        await _viewModel.deleteGame();
        AppNavigator(context: context).pop();
      },
      icon: AppIcon.closeIcon,
      label: Text(AppLocalizations.of(context)!.deleteGame),
    );
  }

  Text roomCodeText() {
    return Text(
      "${AppLocalizations.of(context)!.gameCode}: ${_viewModel.roomModel.roomCode}",
      style: AppTheme.headline4?.copyWith(
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
          )),
      child: Padding(
        padding: context.paddingLow,
        child: Column(children: [
          Text(AppLocalizations.of(context)!.players,
              style: AppTheme.headline4),
          AppSize.mediumHeightSizedBox,
          playersList(),
          AppSize.lowHeightSizedBox,
          openChatOutlinedButton()
        ]),
      ),
    );
  }

  SingleChildScrollView playersList() {
    return SingleChildScrollView(
      child: SizedBox(
        height: context.height * 0.32,
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: _viewModel.playersList!.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => playersListItem(context, index),
        ),
      ),
    );
  }

  Padding playersListItem(BuildContext context, int index) {
    return Padding(
      padding: context.paddingLow,
      child: ListTile(
        title: Text(
          _viewModel.playersList![index].userName.toString(),
          style: AppTheme.headline6,
        ),
        subtitle: Text(
          _viewModel.playersList![index].userStatus == true
              ? AppLocalizations.of(context)!.playersReady
              : AppLocalizations.of(context)!.playersNotReady,
          style: AppTheme.subtitle1,
        ),
        trailing: _viewModel.playersList![index].userStatus == true
            ? AppIcon.colorfulIcon(
                appColor: AppColor.greenColor,
                appIcon: AppIcon.check,
              )
            : AppIcon.colorfulIcon(
                appColor: AppColor.redColor,
                appIcon: AppIcon.info,
              )
      ),
    );
  }

  OutlinedButton openChatOutlinedButton() {
    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          enableDrag: true,
          isDismissible: true,
          context: context,
          builder: (context) => const ChatBommSheetWidget(),
        );
      },
      icon: AppIcon.chatIcon,
      label: Text(AppLocalizations.of(context)!.chat),
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
                }),
          ],
        ),
        _viewModel.roomModel.roomStatus != "started"
            ? startGameElevatedButton()
            : errorWidget(),
      ],
    );
  }

  ElevatedButton startGameElevatedButton() {
    return ElevatedButton(
      onPressed: () async {
        bool isGameStarted = await _viewModel.startGame();
        if (isGameStarted) {
          AppNavigator(context: context).push(
            route: Routes.gameCard,
          );
        }
      },
      child: Text(
        AppLocalizations.of(context)!.startGame,
        style: Theme.of(context).textTheme.button,
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
              )),
        ],
      ),
    );
  }

  Padding roomPlayerPadding() {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          ),
          AppSize.mediumHeightSizedBox,
          Text(
            "${_viewModel.roomModel.roomCreator} ${AppLocalizations.of(context)!.waitingToStart}",
            style: AppTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          AppSize.mediumHeightSizedBox,
          setPlayerStatusRow(),
        ],
      ),
    );
  }

  Row setPlayerStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () async {
              await _viewModel.setPlayerStatus(false);
            },
            child: Text(
              AppLocalizations.of(context)!.notReady,
              style: Theme.of(context).textTheme.button,
            )),
        AppSize.mediumWidthSizedBox,
        ElevatedButton(
          onPressed: () async {
            await _viewModel.setPlayerStatus(true);
          },
          child: Text(
            AppLocalizations.of(context)!.ready,
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ],
    );
  }
}
