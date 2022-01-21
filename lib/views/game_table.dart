import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class GameTableScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  GameTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_viewModel.roomModel.roomThirdWinner == null) {
                bool isNumberTaken = await _viewModel.takeNumber();
                if (isNumberTaken) {
                  AwesomeDialog(
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
                  ).show();
                } else {}
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Oyun Bitti',
                  desc: 'Tekrar oynamak ister misiniz?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();

                Navigator.of(context).popAndPushNamed("/");
              }
            },
            label: _viewModel.isThirdAnounced
                ? Text("Oyun Sona erdi, hemen yeni oyuna başla")
                : Text("Taş Çek"),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* StreamBuilder<DocumentSnapshot>(
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
                            Text("Game loading",
                                style: TextStyle(fontSize: 20)),
                          ],
                        );
                      }

                      if (snapshot.hasData) {
                        var data = snapshot.data!.get("allNumbersList");

                        var isFirstAnounced =
                            snapshot.data!.get("isFirstAnounced");

                        _viewModel.isFirstAnounced = isFirstAnounced;

                        var isSecondAnounced =
                            snapshot.data!.get("isSecondAnounced");

                        _viewModel.isSecondAnounced = isSecondAnounced;

                        var isThirdAnounced =
                            snapshot.data!.get("isThirdAnounced");

                        _viewModel.isThirdAnounced = isThirdAnounced;

                        var firstWinner = snapshot.data!.get("firstWinner");

                        _viewModel.firstWinner = firstWinner;

                        var secondWinner = snapshot.data!.get("secondWinner");

                        _viewModel.secondWinner = secondWinner;

                        var thirdWinner = snapshot.data!.get("thirdWinner");

                        _viewModel.thirdWinner = thirdWinner;

                        _viewModel.allNumbersListDatabase = data;

                        /* if (_viewModel.isFirstAnounced &&
                            _viewModel.isFirstAnouncedChecked == false) {
                          _viewModel.isFirstAnouncedChecked = true;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.SCALE,
                            autoHide: Duration(seconds: 10),
                            dialogBackgroundColor: Colors.blue,
                            body: Container(
                              height: 200,
                              width: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _viewModel.firstWinner.toString(),
                                      style: TextStyle(fontSize: 42),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '1. Çinko Yapan Oyuncu',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).show();
                        }
                        if (_viewModel.isSecondAnounced &&
                            _viewModel.isSecondAnouncedChecked == false) {
                          _viewModel.isSecondAnouncedChecked = true;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.SCALE,
                            autoHide: Duration(seconds: 10),
                            dialogBackgroundColor: Colors.blue,
                            body: Container(
                              height: 200,
                              width: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _viewModel.secondWinner.toString(),
                                      style: TextStyle(fontSize: 42),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '2. Çinko Yapan Oyuncu',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).show();
                        }
                        if (_viewModel.isThirdAnounced &&
                            _viewModel.isThirdAnouncedChecked == false) {
                          _viewModel.isThirdAnouncedChecked = true;
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.SCALE,
                            autoHide: Duration(seconds: 10),
                            dialogBackgroundColor: Colors.blue,
                            body: Container(
                              height: 200,
                              width: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _viewModel.secondWinner.toString(),
                                      style: TextStyle(fontSize: 42),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Tombala Yapan Oyuncu',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).show();
                        }*/

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (() {
                                        if (_viewModel
                                            .allNumbersListDatabase.isEmpty) {
                                          return "Oyun Bitti";
                                        } else if (_viewModel.isThirdAnounced) {
                                          return "Bingo yapan: ${_viewModel.thirdWinner}";
                                        } else if (_viewModel
                                            .isSecondAnounced) {
                                          return "2. çinko yapan: ${_viewModel.secondWinner}";
                                        } else if (_viewModel.isFirstAnounced) {
                                          return "1. çinko yapan: ${_viewModel.firstWinner}";
                                        } else {
                                          return "";
                                        }
                                      }()),
                                    ),
                                    Text(
                                      "En son çekilen sayı:  ${_viewModel.randomNumber}",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              //color: Colors.amberAccent,
                              height: MediaQuery.of(context).size.height - 70,
                              width: MediaQuery.of(context).size.width,
                              child: GridView.builder(
                                padding: EdgeInsets.all(0),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.height /
                                                8),
                                itemCount: 99,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    color: //_viewModel.allNumbersListDatabase
                                        // .contains(_viewModel.allNumbersListTable[index])
                                        _viewModel.allNumbersListDatabase
                                                .contains(_viewModel
                                                    .allNumbersListTable[index])
                                            ? Colors.red
                                            : Colors.green,
                                    child: Center(
                                      child: Text(
                                        "${index + 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _viewModel.isFirstAnounced
                                      ? Text(
                                          "1. Çinko Yapan Oyuncu" +
                                              _viewModel.firstWinner.toString(),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _viewModel.isSecondAnounced
                                      ? Text(
                                          "2. Çinko Yapan Oyuncu" +
                                              _viewModel.secondWinner
                                                  .toString(),
                                        )
                                      : SizedBox(),
                                  _viewModel.isThirdAnounced
                                      ? Text(
                                          "Tombala Yapan Oyuncu" +
                                              _viewModel.secondWinner
                                                  .toString(),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return SizedBox();
                    },
                  ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
