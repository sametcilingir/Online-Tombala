import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';

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
    _viewModel.roomStream();
    _viewModel.playersStream();
    _viewModel.messageStream();

    if (_viewModel.roomModel.roomCreator != _viewModel.userName) {
      //burdaki navigatipn her şeyi değiştiriyor
      reaction(
          (_) => _viewModel.roomModel.roomStatus,
          (string) => string == "started"
              ? Navigator.pushNamed(context, '/home/game_card')
              : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
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
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  "Oyun kodu: ${_viewModel.roomModel.roomCode}",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                      Text("Oyuncular", style: TextStyle(fontSize: 35)),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.builder(
                            addAutomaticKeepAlives: true,
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
                            Navigator.of(context).pushNamed('/home/game_table');
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 20),
                            Text(
                                "${_viewModel.roomModel.roomCreator} başlatması bekleniyor...",
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 20),
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
                                      style: Theme.of(context).textTheme.button,
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
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: AnimatedContainer(
          alignment: Alignment.bottomCenter,
          color: Colors.black54,
          height: _viewModel.isChatOpen! ? 550 : 50,
          width: MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 500),
          child: _viewModel.isChatOpen!
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _viewModel.isChatOpen = false;
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        height: 400,
                        color: Colors.black12,
                        child: ListView.builder(
                          itemCount: _viewModel.messageList!.length,

                          ///bu kod çok önemli
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true,
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                _viewModel.messageList![index].messageText
                                    .toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                _viewModel.messageList![index].messageSenderName
                                    .toString(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          child: Form(
                            key: _viewModel.formKeyMessageWaiting,
                            child: TextFormField(
                              controller: _viewModel.messageControllerWaiting,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "Mesaj ",
                                fillColor: Colors.green,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffix: ElevatedButton(
                                  onPressed: () async {
                                    var val = _viewModel
                                        .formKeyMessageWaiting.currentState!
                                        .validate();
                                    if (val &&
                                        _viewModel.singleMessage!.isNotEmpty) {
                                      _viewModel
                                          .formKeyMessageWaiting.currentState!
                                          .save();

                                      bool isMassageSent =
                                          await _viewModel.sendMessage();

                                      if (isMassageSent) {
                                        _viewModel.singleMessage = "";
                                        _viewModel.messageControllerWaiting!
                                            .clear();
                                      }
                                    }
                                  },
                                  child: Text("Gönder"),
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  //return "Boş olamaz";
                                } else if (val.length.isNaN) {
                                  //return "Boş olamaz";
                                } else {
                                  //return 'Hatasız';
                                }
                              },
                              onChanged: (value) {
                                _viewModel.singleMessage = value;
                              },
                              /* onSaved: (newValue) {
                                  _viewModel.singleMessage = newValue;
                                },*/
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chat",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {
                          _viewModel.isChatOpen = true;
                        },
                        icon: Icon(
                          Icons.arrow_drop_up,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
