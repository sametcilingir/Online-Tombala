import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';

class GameCardScreen extends StatefulWidget {
  const GameCardScreen({Key? key}) : super(key: key);

  @override
  State<GameCardScreen> createState() => _GameCardScreenState();
}

class _GameCardScreenState extends State<GameCardScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _viewModel.roomStream();
    _viewModel.messageStream();

    _viewModel.takenNumberReaction = reaction(
        (_) => _viewModel.takenNumber,
        (v) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              _viewModel.snackbar(
                  Colors.amber, "Çekilen Sayı: ${_viewModel.takenNumber}"),
            ),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomFirstWinner,
        (firstWinner) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              _viewModel.snackbar(
                  Colors.green, "1. Çinko yapıldı: $firstWinner"),
            ),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomSecondWinner,
        (secondWinner) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              _viewModel.snackbar(
                  Colors.green, "2. Çinko yapıldı: $secondWinner"),
            ),
        delay: 1000);

    _viewModel.firstWinnerReaction = reaction(
        (_) => _viewModel.roomModel.roomThirdWinner,
        (thirdWinner) =>
            _viewModel.gameCardScaffoldMessengerKey.currentState?.showSnackBar(
              _viewModel.snackbar(
                  Colors.green, "Tombala yapıldı: $thirdWinner"),
            ),
        delay: 1000);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _viewModel.takenNumberReaction;
    _viewModel.firstWinnerReaction;
    _viewModel.secondWinnerReaction;
    _viewModel.thirdWinnerReaction;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance!.addPostFrameCallback((_) {});

    return Observer(
      builder: (_) {
        return ScaffoldMessenger(
          key: _viewModel.gameCardScaffoldMessengerKey,
          child: Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.amber,
                label: (() {
                  if (_viewModel.roomModel.roomFirstWinner == "") {
                    return Text("Birinci Çinko İlan et");
                  } else if (_viewModel.roomModel.roomSecondWinner == "") {
                    return Text("İkinci Çinko İlan et");
                  } else if (_viewModel.roomModel.roomThirdWinner == "") {
                    return Text("Tombala İlan et");
                  } else {
                    return Text("Oyun Bitti, Yeniden Oynamak İster misin?");
                  }
                }()),
                icon: Icon(Icons.check),
                onPressed: () async {
                  if (_viewModel.roomModel.roomFirstWinner == "") {
                    bool isWin = await _viewModel.winnerControl(1);
                    if (!isWin) {
                      print("burdayız");
                      _viewModel.gameCardScaffoldMessengerKey.currentState
                          ?.showSnackBar(
                        _viewModel.snackbar(Colors.red,
                            "1.Çinko Yapılamadı, lütfen taşlarınızı kontrol ediniz."),
                      );
                    }
                  } else if (_viewModel.roomModel.roomSecondWinner == "") {
                    bool isWin = await _viewModel.winnerControl(2);
                    if (!isWin) {
                      _viewModel.gameCardScaffoldMessengerKey.currentState
                          ?.showSnackBar(
                        _viewModel.snackbar(Colors.red,
                            "2.Çinko Yapılamadı, lütfen taşlarınızı kontrol ediniz."),
                      );
                    }
                  } else if (_viewModel.roomModel.roomThirdWinner == "") {
                    bool isWin = await _viewModel.winnerControl(3);
                    if (!isWin) {
                      _viewModel.gameCardScaffoldMessengerKey.currentState
                          ?.showSnackBar(
                        _viewModel.snackbar(Colors.red,
                            "Tombala Yapılamadı, lütfen taşlarınızı kontrol ediniz."),
                      );
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
            body: Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        //color: Colors.amber,
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          //listeyi canlı tutar
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,

                          scrollDirection: Axis.horizontal,
                          itemCount: 27,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent:
                                MediaQuery.of(context).size.width / 10.5,
                          ),
                          itemBuilder: (context, index) => index.floor().isEven
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _viewModel.randomColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: _viewModel.randomColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        focusColor: Colors.green[100],
                                        splashColor: Colors.green[100],
                                        hoverColor: Colors.green[100],
                                        highlightColor: Colors.green[100],
                                        onTap: () {
                                          if (_viewModel
                                              .takenNumbersListFromDatabase
                                              .contains(
                                                  _viewModel.cardNumbersList[
                                                      index ~/ 2])) {
                                            _viewModel.takenNumbersMap.update(
                                                _viewModel.cardNumbersList[
                                                    index ~/ 2],
                                                (value) => true);

                                            setState(() {});
                                            print("Bu sayı çekilmiş");
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
                                                  color: _viewModel
                                                              .takenNumbersMap[
                                                          _viewModel
                                                                  .cardNumbersList[
                                                              index ~/ 2]]!
                                                      ? Colors.green.shade100
                                                          .withOpacity(0.3)
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    width: 4,
                                                    color: _viewModel
                                                                .takenNumbersMap[
                                                            _viewModel
                                                                    .cardNumbersList[
                                                                index ~/ 2]]!
                                                        ? Colors.green.shade200
                                                        : Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(40)),
                                                ),
                                              ),
                                              Text(
                                                _viewModel
                                                    .cardNumbersList[index ~/ 2]
                                                    .toString(),
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomFirstWinner!.isNotEmpty
                          ? Text(
                              "İlk çinkoyu yapan kişi : ${_viewModel.roomModel.roomFirstWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomSecondWinner!.isNotEmpty
                          ? Text(
                              "İkinci çinkoyu yapan kişi : ${_viewModel.roomModel.roomSecondWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                          ? Text(
                              "Bingo yapan kişi : ${_viewModel.roomModel.roomThirdWinner}")
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: AnimatedContainer(
              alignment: Alignment.bottomCenter,
              color: Colors.black54,
              height: _viewModel.isChatOpen! ? 350 : 50,
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
                            height: 210,
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
                                    hintText: "Mesaj ",
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
                                            _viewModel
                                                .singleMessage!.isNotEmpty) {
                                          _viewModel.formKeyMessageGameCard
                                              .currentState!
                                              .save();

                                          bool isMassageSent =
                                              await _viewModel.sendMessage();

                                          if (isMassageSent) {
                                            _viewModel.singleMessage = "";
                                            _viewModel
                                                .messageControllerGameCard!
                                                .clear();
                                          }
                                        }
                                      },
                                      child: Text("Gönder"),
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
                                    _viewModel.singleMessage = value;
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
                            "Chat",
                            style: TextStyle(fontSize: 16, color: Colors.green),
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
        );
      },
    );
  }

  Widget blankWidget(int index) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: _viewModel.randomColor,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
