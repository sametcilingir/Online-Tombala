import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';

class GameTableScreen extends StatefulWidget {
  const GameTableScreen({Key? key}) : super(key: key);

  @override
  State<GameTableScreen> createState() => _GameTableScreenState();
}

class _GameTableScreenState extends State<GameTableScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel.roomStream();
    _viewModel.messageStream();

    _viewModel.takenNumberReaction = reaction(
        (_) => _viewModel.takenNumber,
        (v) =>
            _viewModel.gameTableScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                dismissDirection: DismissDirection.horizontal,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.amber,
                content: Text("Çekilen Sayı: ${_viewModel.takenNumber}"),
              ),
            ),
        delay: 1000);
    /* if (_viewModel.isFirstAnounced &&
                            _viewModel.isFirstAnouncedChecked == false) {
                          _viewModel.isFirstAnouncedChecked = true;
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
                        }*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _viewModel.takenNumberReaction;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ScaffoldMessenger(
          key: _viewModel.gameTableScaffoldMessengerKey,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: double.infinity,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (() {
                        if (_viewModel.numbersList.isEmpty) {
                          return "Oyun Bitti";
                        } else if (_viewModel
                            .roomModel.roomThirdWinner!.isNotEmpty) {
                          return "Bingo yapan: ${_viewModel.roomModel.roomThirdWinner}";
                        } else if (_viewModel
                            .roomModel.roomSecondWinner!.isNotEmpty) {
                          return "2. çinko yapan: ${_viewModel.roomModel.roomSecondWinner}";
                        } else if (_viewModel
                            .roomModel.roomFirstWinner!.isNotEmpty) {
                          return "1. çinko yapan: ${_viewModel.roomModel.roomFirstWinner}";
                        } else {
                          return "Daha kimse çinko yapmadı.";
                        }
                      }()),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "En son çekilen sayı:  ${_viewModel.takenNumber}",
                    ),
                  ),
                )
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.amber,
                label: _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                    ? Text("Oyun Sona erdi, hemen yeni oyuna başla")
                    : Text(
                        "Taş Çek",
                      ),
                onPressed: () async {
                  
                  if (_viewModel.roomModel.roomThirdWinner!.isEmpty) {
                    await _viewModel.takeNumber();

                    /*  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      animType: AnimType.SCALE,
                      autoHide: Duration(seconds: 5),
                      dialogBackgroundColor: Colors.green,
                      body: Container(
                        height: 200,
                        width: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _viewModel.takenNumber.toString(),
                                style: TextStyle(fontSize: 42),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Çekilen sayi',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).show();*/
                  } else {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    /* AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Oyun Bitti',
                      desc: 'Tekrar oynamak ister misiniz?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show();
                    */
                    //Navigator.of(context).popAndPushNamed("/");
                  }
                },
              ),
            ),
            body: GridView.builder(
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.height / 8),
              itemCount: 99,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: //_viewModel.allNumbersListDatabase
                          // .contains(_viewModel.allNumbersListTable[index])
                          _viewModel.takenNumbersList.contains(index + 1)
                              ? Colors.green
                              : Colors.red,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text("${index + 1}",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                );
              },
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
                                    _viewModel
                                        .messageList![index].messageSenderName
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
                                key: _viewModel.formKeyMessageGameTable,
                                child: TextFormField(
                                  controller:
                                      _viewModel.messageControllerGameTable,
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
                                            .formKeyMessageGameTable
                                            .currentState!
                                            .validate();
                                        if (val &&
                                            _viewModel
                                                .singleMessage!.isNotEmpty) {
                                          _viewModel.formKeyMessageGameTable
                                              .currentState!
                                              .save();

                                          bool isMassageSent =
                                              await _viewModel.sendMessage();

                                          if (isMassageSent) {
                                            _viewModel.singleMessage = "";
                                            _viewModel
                                                .messageControllerGameTable!
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
          ),
        );
      },
    );
  }
}
