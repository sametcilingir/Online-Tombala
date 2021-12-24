import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class GameCardScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: Observer(
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                   height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: _viewModel.gameDocumentFuture(),
                    
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

                      if (snapshot.connectionState == ConnectionState.done) {
                       
                        /*return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 100,
                      mainAxisSpacing: 00
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return widget(index);
                    },
                  );*/

                        return Container(
                          child: Column(
                            children: [
                              Container(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  //semanticChildCount: 27,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 27,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent:
                                        MediaQuery.of(context).size.width / 9,

                                    //mainAxisExtent: 100,
                                    //mainAxisSpacing: 00,
                                  ),
                                  itemBuilder: (context, index) =>
                                      index.floor().isEven
                                          ? numberWidget(index, context)
                                          : blankWidget(index),
                                ),
                              ),
                              /*Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? numberWidget(index)
                                      : blankWidget(index);
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? blankWidget(index)
                                      : numberWidget(index + 3);
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? numberWidget(index + 1)
                                      : blankWidget(index);
                                },
                              ),
                            ),*/
                            ],
                          ),
                        );
                      }

                      return SizedBox();
                    },),
                ),
              /* Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<DocumentSnapshot>(
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
                        var data = snapshot.data!.get("allNumbersList");

                        _viewModel.allNumbersListDatabase = data;

                        /*return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 100,
                      mainAxisSpacing: 00
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return widget(index);
                    },
                  );*/

                        return Container(
                          child: Column(
                            children: [
                              Container(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  //semanticChildCount: 27,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 27,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent:
                                        MediaQuery.of(context).size.width / 9,

                                    //mainAxisExtent: 100,
                                    //mainAxisSpacing: 00,
                                  ),
                                  itemBuilder: (context, index) =>
                                      index.floor().isEven
                                          ? numberWidget(index, context)
                                          : blankWidget(index),
                                ),
                              ),
                              /*Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? numberWidget(index)
                                      : blankWidget(index);
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? blankWidget(index)
                                      : numberWidget(index + 3);
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return index.floor().isEven
                                      ? numberWidget(index + 1)
                                      : blankWidget(index);
                                },
                              ),
                            ),*/
                            ],
                          ),
                        );
                      }

                      return SizedBox();
                    },
                  ),
                ),
              */],
            ),
          );
        },
      ),
    );
  }

  Widget numberWidget(int index, BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          border: Border.all(
            color: _viewModel.randomColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        focusColor: Colors.green[100],
        splashColor: Colors.green[100],
        hoverColor: Colors.green[100],
        highlightColor: Colors.green[100],
        onTap: () {
          _viewModel.checkMyNumber(context);
        },
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
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
