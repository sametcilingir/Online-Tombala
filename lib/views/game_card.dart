import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    return Observer(builder: (_) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () async {}),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
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
                        var allNumbersListData =
                            snapshot.data!.get("allNumbersList");

                        _viewModel.allNumbersListDatabase = allNumbersListData;

                        var takenNumbersListData =
                            snapshot.data!.get("takenNumbersList");

                        _viewModel.takenNumbersListDatabase =
                            takenNumbersListData;

                        return Observer(builder: (_) {
                          return Column(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  addAutomaticKeepAlives: true,

                                  //semanticChildCount: 27,
                                  shrinkWrap: true,
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
                                          return AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 500),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    _viewModel.getColor(index),
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

                                                //bu problemi çöz
                                                setState(() {});
                                              },
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10))),
                                                child: Center(
                                                  child: Text(
                                                    '${_viewModel.randomNumbersForCards[index]}',
                                                    style: TextStyle(
                                                      color: _viewModel
                                                          .randomColor,
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              _viewModel.allNumbersListDatabase.isEmpty
                                  ? Text("Oyun bitti")
                                  : SizedBox(),
                            ],
                          );
                        });
                      }

                      return SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ));
    });
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
