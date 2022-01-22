import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

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
    /* if (_viewModel.cardNumbersList.isEmpty) {
      _viewModel.createGameCard();
    }*/
    /*_viewModel.gameDocumentStream().forEach((e) => AwesomeDialog(
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
                      _viewModel.takenNumbersListDatabase!.last.toString(),
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
          ).show());*/
    _viewModel.roomStream();
    _viewModel.messageStream();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    reaction(
        (_) => _viewModel.takenNumber,
        (v) => awsomeDialog(context, _viewModel.takenNumber.toString(),
                "Çekilen Sayı", Colors.red[900]!)
            .show());

    if (!_viewModel.firstWinnerAnnouncement) {
      reaction(
          (_) => _viewModel.roomModel.roomFirstWinner,
          (roomFirstWinner) => awsomeDialog(context, roomFirstWinner.toString(),
                  "1. Çinko yapıldı", Colors.green)
              .show());
      _viewModel.firstWinnerAnnouncement = true;
    }
    if (!_viewModel.secondWinnerAnnouncement) {
      reaction(
          (_) => _viewModel.roomModel.roomSecondWinner,
          (roomSecondWinner) => awsomeDialog(context,
                  roomSecondWinner.toString(), "2. Çinko yapıldı", Colors.green)
              .show());
      _viewModel.secondWinnerAnnouncement = true;
    }
    if (!_viewModel.thirdWinnerAnnouncement) {
      reaction(
          (_) => _viewModel.roomModel.roomThirdWinner,
          (roomThirdWinner) => awsomeDialog(context, roomThirdWinner.toString(),
                  "3. Çinko yapıldı", Colors.green)
              .show());
      _viewModel.thirdWinnerAnnouncement = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {});

    return Observer(
      builder: (_) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            label: (() {
              if (_viewModel.roomModel.roomFirstWinner!.isEmpty) {
                return Text("Birinci Çinko İlan et");
              } else if (_viewModel.roomModel.roomSecondWinner!.isEmpty) {
                return Text("İkinci Çinko İlan et");
              } else if (_viewModel.roomModel.roomThirdWinner!.isEmpty) {
                return Text("Tombala İlan et");
              } else {
                return Text("Oyun Bitti, Yeniden Oynamak İster misin?");
              }
            }()),
            icon: Icon(Icons.add),
            onPressed: () {
              /*  SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.portraitUp,
                ]);
                Navigator.of(context).popAndPushNamed("/home");*/
            },
          ),
          appBar: AppBar(
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
            title: Text(_viewModel.takenNumbersListFromDatabase.isNotEmpty
                ? "Çekilen Sayı : " +
                    _viewModel.takenNumbersListFromDatabase.last.toString()
                : "Çekilen Sayı : "),
            centerTitle: true,
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
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: 350,
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
                                  MediaQuery.of(context).size.width / 9,
                            ),
                            itemBuilder: (context, index) => index
                                    .floor()
                                    .isEven
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _viewModel.randomColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Material(
                                      child: InkWell(
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
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              color: _viewModel.takenNumbersMap[
                                                      _viewModel
                                                              .cardNumbersList[
                                                          index ~/ 2]]!
                                                  ? Colors.green[800]
                                                  : Colors.white,
                                              border: Border.all(),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              _viewModel
                                                  .cardNumbersList[index ~/ 2]
                                                  .toString(),
                                              style: TextStyle(
                                                color: _viewModel.randomColor,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
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
              ],
            ),
          ),
        );
      },
    );
  }

  AwesomeDialog awsomeDialog(
      BuildContext context, String title, String content, Color color) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 1),
      dialogBackgroundColor: color,
      body: Container(
        height: 200,
        width: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 42),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                content,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget blankWidget(int index) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: _viewModel.randomColor,
        ));
  }
}
