import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

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
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        
        return Scaffold(
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
                      } else if (_viewModel.roomModel.roomThirdWinner!.isNotEmpty) {
                        return "Bingo yapan: ${_viewModel.roomModel.roomThirdWinner}";
                      } else if (_viewModel.roomModel.roomSecondWinner !.isNotEmpty) {
                        return "2. çinko yapan: ${_viewModel.roomModel.roomSecondWinner}";
                      } else if (_viewModel.roomModel.roomFirstWinner !.isNotEmpty) {
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
          floatingActionButton: FloatingActionButton.extended(
            label: _viewModel.roomModel.roomThirdWinner!.isNotEmpty
                ? Text("Oyun Sona erdi, hemen yeni oyuna başla")
                : Text(
                    "Taş Çek",
                    style: TextStyle(color: Colors.white),
                  ),
            onPressed: () async {
              
              if (_viewModel.roomModel.roomThirdWinner!.isEmpty) {
                await _viewModel.takeNumber();

                AwesomeDialog(
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
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Oyun Bitti',
                  desc: 'Tekrar oynamak ister misiniz?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                ).show();

                //Navigator.of(context).popAndPushNamed("/");
              }
            },
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
        );
      },
    );
  }
}
