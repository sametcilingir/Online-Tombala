import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class GameTableScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: (() {
              if (_viewModel.isFirstAnounced) {
                return Text(
                  "1. çinko yapan: ${_viewModel.firstWinner}",
                  style: TextStyle(fontSize: 14),
                );
              } else if (_viewModel.isSecondAnounced) {
                return Text(
                  "2. çinko yapan: ${_viewModel.secondWinner}",
                  style: TextStyle(fontSize: 14),
                );
              } else if (_viewModel.isThirdAnounced) {
                return Text(
                  "Bingo yapan: ${_viewModel.thirdWinner}",
                  style: TextStyle(fontSize: 14),
                );
              }
            }()),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    '${_viewModel.randomNumber == null ? '' : "En son çekilen sayı:  ${_viewModel.randomNumber}"}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (!_viewModel.isThirdAnounced) {
                _viewModel.takeNumber(context: context);
              } else {
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
                  StreamBuilder<DocumentSnapshot>(
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

                        if (_viewModel.isFirstAnounced) {
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
                        } else if (_viewModel.isSecondAnounced) {
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
                        } else if (_viewModel.isThirdAnounced) {
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
                        }

                        return Container(
                          height: MediaQuery.of(context).size.height - 80,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        MediaQuery.of(context).size.height / 8),
                            itemCount: 99,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 20,
                                width: 20,
                                color: //_viewModel.allNumbersListDatabase
                                    // .contains(_viewModel.allNumbersListTable[index])
                                    _viewModel.allNumbersListDatabase.contains(
                                            _viewModel
                                                .allNumbersListTable[index])
                                        ? Colors.red
                                        : Colors.green,
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
