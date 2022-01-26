import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/utils/constants/string_constants.dart';
import 'package:tombala/utils/routes/routes.dart';
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

    _viewModel.createGameCard();

    _viewModel.roomStream();
    _viewModel.playersStream();
    _viewModel.messageStream();

    if (_viewModel.roomModel.roomId == null) {
      
      reaction(
          (_) => _viewModel.roomModel.roomId,
          (string) => string == "null"
              ? Navigator.of(context).pushNamed(Routes.home)
              : null);
    }

    if (_viewModel.roomModel.roomCreator != _viewModel.userName) {
      //burdaki navigatipn her şeyi değiştiriyor
      //reaktion dispose ekle
      reaction(
          (_) => _viewModel.roomModel.roomStatus,
          (string) => string == "started"
              ? Navigator.pushNamed(context, Routes.gameCard)
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
                                await _viewModel.deleteGame();
                                Navigator.of(context)
                                    .popAndPushNamed(Routes.home);
                              },
                              icon: Icon(Icons.close),
                              label: Text(StringConstants.deleteGame),
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
                  "${StringConstants.gameCode}: ${_viewModel.roomModel.roomCode}",
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
                      Text(StringConstants.players,
                          style: TextStyle(fontSize: 35)),
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
                                      ? StringConstants.playersReady
                                      : StringConstants.playersNotReady,
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringConstants.autoTakeNumber,
                              ),
                              Switch(
                                  value: _viewModel.isGameAutoTakeNumber,
                                  onChanged: (value) {
                                    _viewModel.isGameAutoTakeNumber = value;
                                  }),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool isGameStarted = await _viewModel.startGame();
                              if (isGameStarted) {
                                //Navigator.of(context).pushNamed('/home/game_table');
                                Navigator.pushNamed(context, Routes.gameCard);
                              }
                            },
                            child: Text(
                              StringConstants.startGame,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _viewModel.roomModel.roomCreator != _viewModel.userName
                          ? Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(),
                      _viewModel.roomModel.roomCreator != _viewModel.userName
                          ? SizedBox(height: 20)
                          : SizedBox(),
                      _viewModel.roomModel.roomCreator != _viewModel.userName
                          ? Text(
                              "${_viewModel.roomModel.roomCreator} ${StringConstants.waitingToStart}",
                              style: TextStyle(fontSize: 16))
                          : SizedBox(),
                      _viewModel.roomModel.roomCreator != _viewModel.userName
                          ? SizedBox(height: 20)
                          : SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: () async {
                                await _viewModel.setPlayerStatus(false);
                              },
                              child: Text(
                                StringConstants.notReady,
                                style: Theme.of(context).textTheme.button,
                              )),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await _viewModel.setPlayerStatus(true);
                            },
                            child: Text(
                              StringConstants.ready,
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
                                hintText: StringConstants.message,
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
                                  child: Text(StringConstants.send),
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
                        StringConstants.chat,
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
