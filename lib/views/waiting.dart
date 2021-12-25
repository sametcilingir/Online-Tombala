import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Something went wrong",
                            style: TextStyle(fontSize: 20)),
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 50),
                        Text("Game is waiting for players",
                            style: TextStyle(fontSize: 20)),
                      ],
                    );
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
            SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot<Object?>>(
              stream: _viewModel.gameDocumentStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Something went wrong",
                          style: TextStyle(fontSize: 20)),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(width: 50),
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
                    _viewModel.createGameCard();
                    Center(child: CircularProgressIndicator());
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.popAndPushNamed(context, '/game_card');
                    });
                  } else if (data['roomCreator'] == _viewModel.userName) {
                    return ElevatedButton(
                      onPressed: () async {
                        bool isGameStarted = await _viewModel.startGame();
                        if (isGameStarted) {
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GameTableScreen()));*/
                          Navigator.of(context).popAndPushNamed('/game_table');
                        }
                      },
                      child: Text("Start Game"),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 50),
                        Text("Game starting soon",
                            style: TextStyle(fontSize: 20)),
                      ],
                    );
                  }
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
