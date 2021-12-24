import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/game_card.dart';
import 'package:tombala/views/game_table.dart';

class WaitingScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Players", style: TextStyle(fontSize: 50)),
            SizedBox(height: 20),
            Text(
              "Room Key: ${_viewModel.roomId}",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.green[900],
              height: 500,
              width: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream: _viewModel.playersStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['userName'],
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool isGameStarted = await _viewModel.startGame();
                if (isGameStarted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameTableScreen()));
                }
              },
              child: Text("Start Game"),
            ),
            SizedBox(height: 20),
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
                      Text("Game is just about to start",
                          style: TextStyle(fontSize: 20)),
                    ],
                  );
                }

                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      snapshot.data?.data() as Map<String, dynamic>;
                  if (data['isGameStarted'] == true &&
                      data['roomCreator'] != _viewModel.userName) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameCardScreen()));
                  }
                  return Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(width: 20),
                    Text("Game starting soon",
                        style: TextStyle(fontSize: 20)),
                  ],
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
            )
          ],
        ),
      );
    });
  }
}
