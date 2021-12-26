import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class RoomChooseScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             /* Text(
                'Enter the room code to join the game.\n\nIf you don\'t have a room code, create one.',
                style: Theme.of(context).textTheme.headline6,
              ),*/
              Column(
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        //shape: StadiumBorder(),
                        side: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () async {
                        bool createRoomProcces = await _viewModel.createRoom();
                        if (createRoomProcces) {
                          bool joinRoomProcces =
                              await _viewModel.joinRoom(context: context);
                          if (joinRoomProcces) {
                            Navigator.of(context).pushNamed("/waiting_room");
                          } else {
                            print("hata");
                          }
                        } else {
                          print("hata");
                        }
                      },
                      child: Text(
                        'Oda Oluştur',
                        style: Theme.of(context).textTheme.button,
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/room_join");
                      },
                      child: Text(
                        'Odaya gir',
                        style: Theme.of(context).textTheme.button,
                      )),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
