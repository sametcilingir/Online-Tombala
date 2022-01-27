import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../widgets/snack_bar.dart';
import '../../../utils/routes/routes.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';
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

    _viewModel.roomStream();
    _viewModel.messageStream();

    if (_viewModel.roomModel.roomId == null) {
      reaction(
          (_) => _viewModel.roomModel.roomId,
          (string) => string == "null"
              ? Navigator.of(context).pushNamed(Routes.home)
              : null);
    }

    _viewModel.takenNumberReaction =
        reaction((_) => _viewModel.takenNumber, (v) {
      _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBarWidget(
          message:
              "${AppLocalizations.of(context)!.takenNumber} ${_viewModel.takenNumber}",
          color: Colors.amber,
        ).snackBar,
      );
    }, delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomFirstWinner,
        (firstWinner) => _viewModel.gameCardScaffoldMessengerKey.currentState
                ?.showSnackBar(SnackBarWidget(
              message:
                  "${AppLocalizations.of(context)!.theWinner1} : $firstWinner",
              color: Colors.green,
            ).snackBar),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomSecondWinner,
        (secondWinner) => _viewModel.gameCardScaffoldMessengerKey.currentState
                ?.showSnackBar(SnackBarWidget(
              message:
                  "${AppLocalizations.of(context)!.theWinner2} : $secondWinner",
              color: Colors.green,
            ).snackBar),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomThirdWinner,
        (thirdWinner) => _viewModel.gameCardScaffoldMessengerKey.currentState
                ?.showSnackBar(SnackBarWidget(
              message:
                  "${AppLocalizations.of(context)!.theWinner3} : $thirdWinner",
              color: Colors.green,
            ).snackBar),
        delay: 1000);

//auto taş çekme yeri
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
    //WidgetsBinding.instance!.addPostFrameCallback((_) {});

    return Observer(
      builder: (_) {
        return WillPopScope(
          onWillPop: () => Future.sync(
            () {
              if (_viewModel.roomModel.roomStatus != "finished") {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title:  Text(AppLocalizations.of(context)!.attension),
                    content:
                         Text(AppLocalizations.of(context)!.reallyWantToLEave),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child:  Text(AppLocalizations.of(context)!.no),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        child:  Text(AppLocalizations.of(context)!.yes),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }

              return false;
            },
          ),
          child: ScaffoldMessenger(
            key: _viewModel.gameCardScaffoldMessengerKey,
            child: Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.amber,
                  label: (() {
                    if (_viewModel.roomModel.roomFirstWinner == "") {
                      return Text(AppLocalizations.of(context)!.setWinner1);
                    } else if (_viewModel.roomModel.roomSecondWinner == "") {
                      return Text(AppLocalizations.of(context)!.setWinner2);
                    } else if (_viewModel.roomModel.roomThirdWinner == "") {
                      return Text(AppLocalizations.of(context)!.setWinner3);
                    } else {
                      return Text(AppLocalizations.of(context)!.wantToPlay);
                    }
                  }()),
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    if (_viewModel.roomModel.roomFirstWinner == "") {
                      bool isWin = await _viewModel.winnerControl(1);
                      if (!isWin) {
                        _viewModel.gameCardScaffoldMessengerKey.currentState
                            ?.showSnackBar(SnackBarWidget(
                          message:
                              AppLocalizations.of(context)!.controlYourNumbers,
                          color: Colors.red,
                        ).snackBar);
                      }
                    } else if (_viewModel.roomModel.roomSecondWinner == "") {
                      bool isWin = await _viewModel.winnerControl(2);
                      if (!isWin) {
                        _viewModel.gameCardScaffoldMessengerKey.currentState
                            ?.showSnackBar(SnackBarWidget(
                          message:
                              AppLocalizations.of(context)!.controlYourNumbers,
                          color: Colors.red,
                        ).snackBar);
                      }
                    } else if (_viewModel.roomModel.roomThirdWinner == "") {
                      bool isWin = await _viewModel.winnerControl(3);
                      if (!isWin) {
                        _viewModel.gameCardScaffoldMessengerKey.currentState
                            ?.showSnackBar(SnackBarWidget(
                          message:
                              AppLocalizations.of(context)!.controlYourNumbers,
                          color: Colors.red,
                        ).snackBar);
                      }
                    } else {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                ),
              ),
              /* appBar: AppBar(
                leadingWidth: 300,
                leading: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _viewModel.roomModel.roomFirstWinner!.isNotEmpty
                          ? Text("1. Çinko Yapan Oyuncu  :  " +
                              _viewModel.roomModel.roomFirstWinner.toString())
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomSecondWinner!.isNotEmpty
                          ? Text("2. Çinko Yapan Oyuncu  :  " +
                              _viewModel.roomModel.roomSecondWinner.toString())
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                          ? Text("Tombala Yapan Oyuncu  :  " +
                              _viewModel.roomModel.roomThirdWinner.toString())
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                /* title: Text(_viewModel.takenNumbersListFromDatabase.isNotEmpty
                    ? "Çekilen Sayı : " +
                        _viewModel.takenNumbersListFromDatabase.last.toString()
                    : "Çekilen Sayı : "),
                centerTitle: true,*/
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _viewModel.takenNumbersListFromDatabase.length < 2
                          ? "Önceki çekilen sayı: "
                          : "Önceki çekilen sayı:  ${_viewModel.takenNumbersListFromDatabase.elementAt(_viewModel.takenNumbersListFromDatabase.length - 2)}",
                    ),
                  )
                ],
              ),*/
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      gameCardWidget(context),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => gameTableWidget(_viewModel),
                          );
                        },
                        child:
                            Text(AppLocalizations.of(context)!.showGameTable),
                      ),
                      !_viewModel.isGameAutoTakeNumber
                          ? OutlinedButton(
                              onPressed: () async {
                                if (_viewModel
                                    .roomModel.roomThirdWinner!.isEmpty) {
                                  await _viewModel.takeNumber();

                                  /*  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      animType: AnimType.SCALE,
                      autoHide: Duration(seconds: 5),
                      dialogBackgroundColor: Colors.green,
                      body: Container(
                        height: 200,
                        width: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _viewModel.takenNumber.toString(),
                                style: TextStyle(fontSize: 42),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Çekilen sayi',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).show();*/
                                } else {
                                  //Navigator.of(context).popUntil((route) => route.isFirst);

                                }
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.takeNumber),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomFirstWinner!.isNotEmpty
                          ? Text(
                              "${AppLocalizations.of(context)!.theWinner1} : ${_viewModel.roomModel.roomFirstWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomSecondWinner!.isNotEmpty
                          ? Text(
                              "${AppLocalizations.of(context)!.theWinner2} : ${_viewModel.roomModel.roomSecondWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                          ? Text(
                              "${AppLocalizations.of(context)!.theWinner3} : ${_viewModel.roomModel.roomThirdWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
              bottomSheet: AnimatedContainer(
                alignment: Alignment.bottomCenter,
                color: Colors.black54,
                height: _viewModel.isChatOpen! ? 550 : 50,
                width: MediaQuery.of(context).size.width,
                duration: Duration(milliseconds: 500),
                child: _viewModel.isChatOpen!
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _viewModel.isChatOpen = false;
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.green,
                              ),
                            ),
                            Container(
                              height: 400,
                              color: Colors.black12,
                              child: ListView.builder(
                                itemCount: _viewModel.messageList!.length,

                                ///bu kod çok önemli
                                addAutomaticKeepAlives: true,
                                //shrinkWrap: true,
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      _viewModel.messageList![index].messageText
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      _viewModel
                                          .messageList![index].messageSenderName
                                          .toString(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: Form(
                                  key: _viewModel.formKeyMessageGameCard,
                                  child: TextFormField(
                                    controller:
                                        _viewModel.messageControllerGameCard,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText:
                                          AppLocalizations.of(context)!.message,
                                      fillColor: Colors.green,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffix: ElevatedButton(
                                        onPressed: () async {
                                          var val = _viewModel
                                              .formKeyMessageGameCard
                                              .currentState!
                                              .validate();
                                          if (val &&
                                              _viewModel.messageModel
                                                  .messageText!.isNotEmpty) {
                                            _viewModel.formKeyMessageGameCard
                                                .currentState!
                                                .save();

                                            bool isMassageSent =
                                                await _viewModel.sendMessage();

                                            if (isMassageSent) {
                                              _viewModel.messageModel
                                                  .messageText = "";
                                              _viewModel
                                                  .messageControllerGameCard!
                                                  .clear();
                                            }
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!.send),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        //return "Boş olamaz";
                                      } else if (val.length.isNaN) {
                                        //return "Boş olamaz";
                                      } else {
                                        //return 'Hatasız';
                                      }
                                    },
                                    onChanged: (value) {
                                      _viewModel.messageModel.messageText =
                                          value;
                                    },
                                    /* onSaved: (newValue) {
                                    _viewModel.singleMessage = newValue;
                                  },*/
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.chat,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () {
                                _viewModel.isChatOpen = true;
                              },
                              icon: Icon(
                                Icons.arrow_drop_up,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget gameCardWidget(BuildContext context) {
    return Container(
      width: 400,
      child: GridView.builder(
        //listeyi canlı tutar
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 27,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 3,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (context, index) => index.floor().isEven
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: _viewModel.randomColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _viewModel.randomColor),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      focusColor: Colors.green[100],
                      splashColor: Colors.green[100],
                      hoverColor: Colors.green[100],
                      highlightColor: Colors.green[100],
                      onTap: () {
                        if (_viewModel.takenNumbersListFromDatabase
                            .contains(_viewModel.cardNumbersList[index ~/ 2])) {
                          _viewModel.takenNumbersMap.update(
                              _viewModel.cardNumbersList[index ~/ 2],
                              (value) => true);

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
                                    ? Colors.green.shade100.withOpacity(0.3)
                                    : Colors.transparent,
                                border: Border.all(
                                  width: 4,
                                  color: _viewModel.takenNumbersMap[_viewModel
                                          .cardNumbersList[index ~/ 2]]!
                                      ? Colors.green.shade200
                                      : Colors.transparent,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                            ),
                            Text(
                              _viewModel.cardNumbersList[index ~/ 2].toString(),
                              style: TextStyle(
                                color: _viewModel.randomColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : blankWidget(index),
      ),
    );
  }

  Widget blankWidget(int index) {
    return Container(
      decoration: BoxDecoration(
          color: _viewModel.randomColor,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
              color: //_viewModel.allNumbersListDatabase
                  // .contains(_viewModel.allNumbersListTable[index])

                  (() {
                if (_viewModel.roomModel.roomCreator ==
                    _viewModel.playerModel.userName) {
                  return _viewModel.takenNumbersList.contains(index + 1)
                      ? Colors.green
                      : Colors.red;
                } else {
                  return _viewModel.takenNumbersListFromDatabase
                          .contains(index + 1)
                      ? Colors.green
                      : Colors.red;
                }
              }()),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text("${index + 1}",
                  style: Theme.of(context).textTheme.headline5),
            ),
          ),
        );
      },
    );
  }
}
