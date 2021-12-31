import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
          appBar: AppBar(
            centerTitle: false,
            actions: [
              _viewModel.roomCreator == _viewModel.userName
                  ? IconButton(
                      onPressed: () async {
                        await _viewModel.deleteGame();
                        Navigator.of(context).popAndPushNamed("/home");
                      },
                      icon: Icon(Icons.close),
                    )
                  : SizedBox(),
            ],
            leading: _viewModel.roomId == null
                ? BackButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed("/home");
                    },
                  )
                : SizedBox(),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _viewModel.roomId != null
                      ? Text("Oda Numarası: ${_viewModel.roomId}",
                          style: TextStyle(fontSize: 35))
                      : Text("Anasayfaya dön"),
                  SizedBox(height: 50),

                  /* Text(
                        "Room Key: ${_viewModel.roomId}",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 20),*/
                  Container(
                    height: 550,
                    width: 500,
                    margin: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(10.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Oyuncular", style: TextStyle(fontSize: 30)),
                          SizedBox(height: 20),
                          StreamBuilder<QuerySnapshot>(
                            stream: _viewModel.playersStream(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Hata oluştu.",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(width: 50),
                                    Text("Oyuncular bekleniyor...",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                );
                              }

                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                int playersNumber = snapshot.data!.docs.length;

                                _viewModel.playersNumber = playersNumber;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ///webde anlık deği
                                    kIsWeb
                                        ? SizedBox()
                                        : Text("Oyuncu sayısı  " +
                                            (_viewModel.playersNumber)
                                                .toString()),
                                    SizedBox(height: 20),
                                    Container(
                                      height: 430,
                                      width: 500,
                                      child: ListView(
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          _viewModel.playersNumber =
                                              snapshot.data!.docs.length;
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                data['userName'],
                                                style: TextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 50),
                                      Text("Oyuncular bekleniyor...",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Böyle bir oyun yok",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .popAndPushNamed("/home");
                                      },
                                      child: Text(
                                        'Ana sayfaya dön',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      )),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: _viewModel.gameDocumentStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Böyle bir oyun yok",
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .popAndPushNamed("/home");
                                },
                                child: Text(
                                  'Ana sayfaya dön',
                                  style: Theme.of(context).textTheme.button,
                                )),
                          ],
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(width: 50),
                            Text("Oyun başlamaya hazırlanıyor...",
                                style: TextStyle(fontSize: 20)),
                          ],
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.exists) {
                        var roomCreator = snapshot.data!.get("roomCreator");

                        _viewModel.roomCreator = roomCreator;

                        var isGameStarted = snapshot.data!.get("isGameStarted");

                        _viewModel.isGameStarted = isGameStarted;

                        /*    Map<String, dynamic> data =
                            snapshot.data?.data() as Map<String, dynamic>;
                        _viewModel.roomCreator = data["roomCreator"];*/

                        if (_viewModel.isGameStarted == true &&
                            _viewModel.roomCreator != _viewModel.userName) {
                          _viewModel.createGameCard();

                          Future.delayed(Duration(microseconds: 500), () {
                            Navigator.popAndPushNamed(context, '/game_card');
                          });
                        } else if (_viewModel.roomCreator ==
                            _viewModel.userName) {
                          return ElevatedButton(
                            onPressed: () async {
                              bool isGameStarted = await _viewModel.startGame();
                              if (isGameStarted) {
                                Navigator.of(context)
                                    .popAndPushNamed('/game_table');
                              }
                            },
                            child: Text(
                              "Oyunu Başlat",
                              style: Theme.of(context).textTheme.button,
                            ),
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

                      return SizedBox();
                    },
                  )
                ],
              ),
            ),
          ));
    });
  }
}
