import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/room_join.dart';
import 'package:tombala/views/waiting.dart';

class RoomChooseScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Container(
        color: Colors.green.withOpacity(0.5),
        child: Center(
          child: Container(
            color: Colors.red,
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      bool createRoomProcces =
                          await _viewModel.createRoom(context: context);

                      if (createRoomProcces) {
                        bool joinRoomProcces =
                            await _viewModel.joinRoom(context: context);
                        if (joinRoomProcces) {
                          Navigator.of(context)
                              .popAndPushNamed("/waiting_room");
                        } else {
                          print("hata");
                        }
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WaitingScreen()));*/

                      } else {
                        print("hata");
                      }
                    },
                    child: Text('Oda Oluştur')),
                ElevatedButton(
                    onPressed: () {
                      /*Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) => RoomJoinScreen(),));*/
                      Navigator.of(context).popAndPushNamed("/room_join");
                    },
                    child: Text('Odaya gir')),
              ],
            ),
          ),
        ),
      );
    });
  }
}
