import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class GameCardScreen extends StatefulWidget {
  @override
  State<GameCardScreen> createState() => _GameCardScreenState();
}

class _GameCardScreenState extends State<GameCardScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
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

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    initState();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: (() {
          if (!_viewModel.isFirstAnounced) {
            return Text("Birinci Çinko İlan et");
          } else if (!_viewModel.isSecondAnounced) {
            return Text("İkinci Çinko İlan et");
          } else if (!_viewModel.isThirdAnounced) {
            return Text("Tombala İlan et");
          } else {
            return Text("Oyun Bitti, Yeniden Oynamak İster misin?");
          }
        }()),
        icon: Icon(Icons.add),
        onPressed: () {
          if (!_viewModel.isFirstAnounced) {
            _viewModel.birinciCinkoIlanEt(context);
          } else if (!_viewModel.isSecondAnounced) {
            _viewModel.ikinciCinkoIlanEt(context);
          } else if (!_viewModel.isThirdAnounced) {
            _viewModel.tomabalaIlanEt(context);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.of(context).popAndPushNamed("/home");
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(child: Text("")
                  StreamBuilder<DocumentSnapshot<Object?>>(
                stream: _viewModel.gameDocumentStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 20),
                        Text("Game loading", style: TextStyle(fontSize: 20)),
                      ],
                    );
                  }

                  if (snapshot.hasData) {
                    var allNumbersListData =
                        snapshot.data!.get("allNumbersList");

                    _viewModel.allNumbersListDatabase = allNumbersListData;

                    var takenNumbersListDatabase =
                        snapshot.data!.get("takenNumbersList");

                    _viewModel.takenNumbersListDatabase =
                        takenNumbersListDatabase;

                    var isFirstAnounced = snapshot.data!.get("isFirstAnounced");

                    _viewModel.isFirstAnounced = isFirstAnounced;

                    var isSecondAnounced =
                        snapshot.data!.get("isSecondAnounced");

                    _viewModel.isSecondAnounced = isSecondAnounced;

                    var isThirdAnounced = snapshot.data!.get("isThirdAnounced");

                    _viewModel.isThirdAnounced = isThirdAnounced;

                    var firstWinner = snapshot.data!.get("firstWinner");

                    _viewModel.firstWinner = firstWinner;

                    var secondWinner = snapshot.data!.get("secondWinner");

                    _viewModel.secondWinner = secondWinner;

                    var thirdWinner = snapshot.data!.get("thirdWinner");

                    _viewModel.thirdWinner = thirdWinner;

                    var isGameFinished = snapshot.data!.get("isGameFinished");

                    _viewModel.isGameFinished = isGameFinished;

                    return Column(
                      children: [
                        AppBar(
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Önceki çekilen sayı:  ${_viewModel.takenNumbersListDatabase!.elementAt(_viewModel.takenNumbersListDatabase!.length - 2)}",
                              ),
                            )
                          ],
                          leadingWidth: 300,
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _viewModel.isFirstAnounced
                                  ? Text(
                                      "1. Çinko Yapan Oyuncu  :  " +
                                          _viewModel.firstWinner.toString(),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              _viewModel.isSecondAnounced
                                  ? Text(
                                      "2. Çinko Yapan Oyuncu  :  " +
                                          _viewModel.secondWinner.toString(),
                                    )
                                  : SizedBox(),
                              _viewModel.isThirdAnounced
                                  ? Text(
                                      "Tombala Yapan Oyuncu  :  " +
                                          _viewModel.secondWinner.toString(),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          automaticallyImplyLeading: false,
                          title: Text("Çekilen Sayı : " +
                              _viewModel.takenNumbersListDatabase!.last
                                  .toString()),
                          centerTitle: true,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
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
                                //? numberWidget(index, context)
                                ? Observer(builder: (_) {
                                    print("index: $index");
                                    return Container(
                                      color: _viewModel.numbersColorMap![
                                          _viewModel
                                              .randomNumbersForCards[index]
                                              .toString()],
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: _viewModel.randomColor,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: InkWell(
                                          focusColor: Colors.green[100],
                                          splashColor: Colors.green[100],
                                          hoverColor: Colors.green[100],
                                          highlightColor: Colors.green[100],
                                          onTap: () async {
                                            await _viewModel.checkMyNumber(
                                                context,
                                                _viewModel
                                                        .randomNumbersForCards[
                                                    index]);

                                            setState(() {});

                                            //_viewModel.setActiveColor =
                                            //  _viewModel.getColor(index);

                                            //bu problemi çöz
                                            //setState(() {});
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                '${_viewModel.randomNumbersForCards[index]}',
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
                                    );
                                  })
                                : blankWidget(index),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _viewModel.allNumbersListDatabase.isEmpty
                            ? Text("Oyun bitti..")
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        _viewModel.isFirstAnounced
                            ? Text(
                                "İlk çinkoyu yapan kişi : ${_viewModel.firstWinner}")
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        _viewModel.isSecondAnounced
                            ? Text(
                                "İkinci çinkoyu yapan kişi : ${_viewModel.secondWinner}")
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        _viewModel.isThirdAnounced
                            ? Text(
                                "Bingo yapan kişi : ${_viewModel.thirdWinner}")
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }

                  return SizedBox();
                },
              )),
                  ),
            ),
          ],
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
