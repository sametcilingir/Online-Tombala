import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel.playersStream();
    _viewModel.roomStream();
    /* if (_viewModel.roomModel.roomStatus == "started" &&
        _viewModel.roomModel.roomCreator != _viewModel.userName) {
      _viewModel.createGameCard();

      Navigator.popAndPushNamed(context, '/game_card');
    }else{
      ///oyunu başlatıcak kişi diğer sayfaya yönlensin
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              _viewModel.roomModel.roomCreator == _viewModel.userName
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          //await _viewModel.deleteGame();
                          //Navigator.of(context).popAndPushNamed("/home");
                        },
                        icon: Icon(Icons.close),
                        label: Text("Oyunu Sil"),
                      ),
                    )
                  : SizedBox(),
            ],
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/home");
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Oda Numarası: ${_viewModel.roomModel.roomCode}",
                    style: TextStyle(fontSize: 35),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 450,
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
                      child: Column(children: [
                        Text("Oyuncular", style: TextStyle(fontSize: 30)),
                        SizedBox(height: 20),
                        ListView.builder(
                          itemCount: _viewModel.playersList!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                _viewModel.playersList![index].userName
                                    .toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                _viewModel.playersList![index].userStatus ==
                                        true
                                    ? "Oyuncu Hazır"
                                    : "Oyuncu Hazır Değil",
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing:
                                  _viewModel.playersList![index].userStatus ==
                                          true
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.info,
                                          color: Colors.red,
                                        ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: 20),
                  _viewModel.roomModel.roomCreator == _viewModel.userName
                      ? ElevatedButton(
                          onPressed: () async {
                            bool isGameStarted = await _viewModel.startGame();
                            if (isGameStarted) {
                              Navigator.of(context)
                                  .pushNamed('/game_table');
                            }
                          },
                          child: Text(
                            "Oyunu Başlat",
                            style: Theme.of(context).textTheme.button,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(height: 10),
                              Text("Oyunkurucunun başlatılması bekleniyor...",
                                  style: TextStyle(fontSize: 16)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      onPressed: () async {
                                        await _viewModel.setPlayerStatus(false);
                                      },
                                      child: Text(
                                        'Hazır Değilim',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      )),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _viewModel.setPlayerStatus(true);
                                    },
                                    child: Text(
                                      'Hazırım',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ));
    });
  }
}
