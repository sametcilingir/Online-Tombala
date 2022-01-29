import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/components/widgets/chat_sheet.dart';
import 'package:tombala/components/widgets/loading_widget.dart';
import 'package:tombala/utils/constants/size_constants.dart';
import 'package:tombala/utils/extension/context_extension.dart';
import 'package:tombala/utils/extension/size_extension.dart';
import '../../../utils/routes/routes.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';
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
      Navigator.of(context).pushNamed(Routes.home);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _viewModel.createGameCard();

    _viewModel.roomStream();
    _viewModel.playersStream();
    _viewModel.messageStream();

    if (_viewModel.roomModel.roomCreator != _viewModel.playerModel.userName) {
      _viewModel.startGameReaction = reaction(
          (_) => _viewModel.roomModel.roomStatus,
          (string) => string == "started"
              ? Navigator.of(context).pushNamed(Routes.gameCard)
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
              SizeConstants().mediumHeight,
              playersContainer(),
              SizeConstants().mediumHeight,
              _viewModel.roomModel.roomCreator ==
                      _viewModel.playerModel.userName
                  ? roomCreatorColumn()
                  : SizeConstants().zeroBox,
              _viewModel.roomModel.roomCreator !=
                      _viewModel.playerModel.userName
                  ? roomPlayerPadding()
                  : SizeConstants().zeroBox,
            ],
          ),
        ),
      ),
    );
  }

  Padding roomPlayerPadding() {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _viewModel.roomModel.roomCreator != _viewModel.playerModel.userName
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                )
              : SizeConstants().zeroBox,
          _viewModel.roomModel.roomCreator != _viewModel.playerModel.userName
              ? SizeConstants().mediumHeight
              : SizeConstants().zeroBox,
          _viewModel.roomModel.roomCreator != _viewModel.playerModel.userName
              ? Text(
                  "${_viewModel.roomModel.roomCreator} ${AppLocalizations.of(context)!.waitingToStart}",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )
              : SizeConstants().zeroBox,
          _viewModel.roomModel.roomCreator != _viewModel.playerModel.userName
              ? SizeConstants().mediumHeight
              : SizeConstants().zeroBox,
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
        SizedBox(width: 20),
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
            ? ElevatedButton(
                onPressed: () async {
                  bool isGameStarted = await _viewModel.startGame();
                  if (isGameStarted) {
                    //Navigator.of(context).pushNamed('/home/game_table');
                    Navigator.pushNamed(context, Routes.gameCard);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.startGame,
                  style: Theme.of(context).textTheme.button,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.isAlreadyStarted),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.back)),
                  ],
                ),
              ),
      ],
    );
  }

  Container playersContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: 500,
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          borderRadius: new BorderRadius.all(
            const Radius.circular(10.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(AppLocalizations.of(context)!.players,
              style: TextStyle(fontSize: 35)),
          SizedBox(height: 20),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: _viewModel.playersList!.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _viewModel.playersList![index].userName.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      _viewModel.playersList![index].userStatus == true
                          ? AppLocalizations.of(context)!.playersReady
                          : AppLocalizations.of(context)!.playersNotReady,
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: _viewModel.playersList![index].userStatus == true
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.info,
                            color: Colors.red,
                          ),
                  ),
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                enableDrag: true,
                isDismissible: true,
                context: context,
                builder: (context) => const ChatBommSheetWidget(),
              );
            },
            icon: Icon(Icons.chat),
            label: Text("Chat"),
          )
        ]),
      ),
    );
  }

  Text roomCodeText() {
    return Text(
      "${AppLocalizations.of(context)!.gameCode}: ${_viewModel.roomModel.roomCode}",
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        _viewModel.roomModel.roomCreator == _viewModel.playerModel.userName
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await _viewModel.deleteGame();
                    Navigator.of(context).popAndPushNamed(Routes.home);
                  },
                  icon: Icon(Icons.close),
                  label: Text(AppLocalizations.of(context)!.deleteGame),
                ),
              )
            : SizedBox(),
      ],
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
