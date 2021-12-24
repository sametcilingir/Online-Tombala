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
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 300,
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
                      //print(snapshot.data!.data());

                      var data = snapshot.data!.get("allNumbersList");

                      // print(a);

                      //_viewModel.allNumbersListDatabaseObservable = a;

                      //print(_viewModel.allNumbersListDatabaseObservable);
                      //print(_viewModel.allNumbersListTableObservable);

                      /*var database =
                          _viewModel.allNumbersListDatabaseObservable!.toList();
                      database = data;
                      var table =
                          _viewModel.allNumbersListTableObservable!.toList();
                      table = List<dynamic>.generate(100, (i) => i + 1)
                          .map((i) => i)
                          .toList();*/

                      _viewModel.allNumbersListDatabase = data;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemCount: 99,
                        itemBuilder: (context, index) {
                          /*print(index);
                          print(database[index]);
                          print(table[index]);
                          if (database.contains(table[index])) {
                            print(true);
                          } else {
                            print(false);

                          }*/
                          return Container(
                            height: 20,
                            width: 20,
                            color: //_viewModel.allNumbersListDatabase
                                // .contains(_viewModel.allNumbersListTable[index])
                                _viewModel.allNumbersListDatabase.contains(_viewModel.allNumbersListTable[index])
                                    ? Colors.red
                                    : Colors.green,
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 20),
                        Text("Game is just about to start",
                            style: TextStyle(fontSize: 20)),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  
                  await _viewModel.takeNumber(context: context);
                },
                child: Text("Take Number"),
              ),
            ],
          ),
        );
      },
    );
  }
}
